import 'dart:async';
import 'package:universal_io/io.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:starter/utils/loading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/profile.dart';
import '../../screens/root.dart';
import 'update_password..dart';
import 'update_profile.dart';

// Initiate Supabase
final supabase = Supabase.instance.client;

class ProfileScreen extends StatefulWidget {
  final ProfileModel? profile;
  const ProfileScreen({Key? key, this.profile}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String? error;
  String? email;
  String? fullName;

  XFile? avatarFile;
  String? avatarPathLocal;
  String? avatarPathOnline;
  String emptyAvatar =
      "https://dfymjnonymnyxvsobdmk.supabase.co/storage/v1/object/public/avatars/emptyAvatar.jpg";

  Future updateProfile(id, fullName, email) async {
    try {
      if (kDebugMode) {
        print('Trying to update profile');
      }
      final avatarFile = File(avatarPathLocal!);
      final String path = await supabase.storage.from('avatars').upload(
            'public/$id.jpg',
            avatarFile,
            fileOptions: const FileOptions(
                contentType: 'image/jpeg', cacheControl: '3600', upsert: true),
          );
      final data = await supabase.from('profiles').update(
          {'full_name': fullName, 'avatar': '$id.jpg'}).match({'id': id});
    } catch (e) {
      setState(() => {loading = false, error = 'Something went wrong'});
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future prepareAvatarOnLoad() async {
    print(widget.profile?.avatar);
    if (widget.profile?.avatar != '') {
      avatarPathOnline = await supabase.storage
          .from('avatars/public')
          .createSignedUrl(widget.profile!.avatar, 60);

      return avatarPathOnline;
    } else {
      return emptyAvatar;
    }
  }

  profileOverview(avatarPath) {
    return Column(
      children: <Widget>[
        kIsWeb
            ? const Text('My Profile',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))
            : Container(),
        const SizedBox(height: 40.0),
        SizedBox(
            height: 120.0,
            width: 120.0,
            child: avatarPathLocal != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(avatarPathLocal!),
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(emptyAvatar),
                  )),

        //   avatarPathLocal != null
        //       ? kIsWeb
        //           ? CircleAvatar(
        //               backgroundImage: NetworkImage(avatarPathLocal!),
        //             )
        //           : CircleAvatar(
        //               backgroundImage: Image.file(File(avatarPathLocal!)),
        //             )
        //       // ignore: unrelated_type_equality_checks, unnecessary_null_comparison
        //       : avatarPath != null
        //           ? CircleAvatar(
        //               backgroundImage: NetworkImage(avatarPath),
        //             )
        //           : CircleAvatar(
        //               backgroundImage: NetworkImage(emptyAvatar),
        //             ),
        // ),
        const SizedBox(height: 50.0),
        Text(
          widget.profile!.fullName,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(widget.profile!.email),
        const SizedBox(height: 50),
        SizedBox(
            width:
                ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
              Condition.largerThan(name: MOBILE, value: 300.0),
              Condition.smallerThan(name: TABLET, value: double.infinity)
            ]).value,
            child: ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('Edit Profile'),
                ),
                onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            UpdateProfileScreen(profile: widget.profile),
                      ))
                    })),
        const SizedBox(height: 20),
        SizedBox(
            width:
                ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
              Condition.largerThan(name: MOBILE, value: 300.0),
              Condition.smallerThan(name: TABLET, value: double.infinity)
            ]).value,
            child: ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('Edit Password'),
                ),
                onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            UpdatePasswordScreen(profile: widget.profile),
                      ))
                    }))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoadingUtil()
        : Scaffold(
            appBar: AppBar(
              title: const Text(!kIsWeb ? 'My profile' : ''),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: FutureBuilder(
                    builder: (ctx, snapshot) {
                      // Checking if future is resolved or not
                      if (snapshot.connectionState == ConnectionState.done) {
                        // If we got an error
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              '${snapshot.error} occurred',
                              style: const TextStyle(fontSize: 18),
                            ),
                          );

                          // if we got our data
                        } else if (snapshot.hasData) {
                          // Extracting data from snapshot object
                          final avatarPathFuture = snapshot.data as String;
                          return profileOverview(avatarPathFuture);
                        }
                      }
                      return const Center(
                        child: LoadingUtil(),
                      );
                    },
                    future: prepareAvatarOnLoad(),
                  ),
                ),
              ),
            ),
          );
  }
}
