import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  late String emptyAvatarPath;

  Future prepareAvatarOnLoad() async {
    await dotenv.load(fileName: ".env");
    emptyAvatarPath = dotenv.env["EMPTY_AVATAR_PATH"]!;
    if (widget.profile?.avatar != '') {
      avatarPathOnline = await supabase.storage
          .from('avatars/public')
          .createSignedUrl(widget.profile!.avatar, 60);
      return avatarPathOnline;
    } else {
      return emptyAvatarPath;
    }
  }

  profileOverview(avatarDownloadPath) {
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
          child: avatarDownloadPath != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(avatarDownloadPath),
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(emptyAvatarPath),
                ),
        ),
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
                        builder: (context) => UpdateProfileScreen(
                            profile: widget.profile,
                            avatarDownloadPath: avatarDownloadPath != null
                                ? avatarDownloadPath
                                : emptyAvatarPath),
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
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              '${snapshot.error} occurred',
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final avatarDownloadPath = snapshot.data as String;
                          return profileOverview(avatarDownloadPath);
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
