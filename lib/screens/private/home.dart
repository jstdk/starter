import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/theme.dart';
import '../../services/local_authentication.dart';
import '../../services/internationalization.dart';
import '../../services/localization.dart';

import '../../models/message.dart';
import '../../models/profile.dart';
import '../../screens/private/profile.dart';
import '../../utils/loading.dart';

final supabase = Supabase.instance.client;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Stream<List<MessageModel>> messages;
  late ProfileModel profile;

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    loadProfile(
        supabase.auth.currentUser!.id, supabase.auth.currentUser!.email!);
    messages = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created')
        .map((maps) => maps
            .map((map) => MessageModel.fromMap(
                map: map, uid: supabase.auth.currentUser!.id))
            .toList());
    super.initState();
  }

  Future loadProfile(String uid, String email) async {
    profile = ProfileModel.fromMap(
        map: await supabase.from('profiles').select().eq('id', uid).single(),
        emailFromAuth: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu_rounded,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(LocalizationService.of(context)!.translate('title')!),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(
                  FontAwesomeIcons.gear,
                  size: 20.0,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<MessageModel>>(
        stream: messages,
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingUtil();
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              final messages = snapshot.data!;
              return ResponsiveRowColumn(
                  layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                      ? ResponsiveRowColumnType.COLUMN
                      : ResponsiveRowColumnType.ROW,
                  rowMainAxisAlignment: MainAxisAlignment.center,
                  rowPadding: const EdgeInsets.all(10),
                  columnPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  children: [
                    ResponsiveRowColumnItem(
                      rowFlex: 1,
                      child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return Card(
                                // In many cases, the key isn't mandatory
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(message.content!),
                                ));
                          }),
                    ),
                    ResponsiveRowColumnItem(
                        rowFlex: 1,
                        child: ResponsiveVisibility(
                          hiddenWhen: const [
                            Condition.smallerThan(name: TABLET)
                          ],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text('YEAHHHHH'),
                              SizedBox(
                                width: 300,
                              )
                            ],
                          ),
                        )),
                  ]);
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
      drawer: const Drawer(child: Text('Text')),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text('Settings'),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Row(children: [
                const Text('My Profile',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.circleChevronRight,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(profile: profile),
                      ),
                    );
                  },
                ),
              ]),
            ),
            const SizedBox(height: 5.0),
            Consumer<ThemeService>(
              builder: (context, theme, child) => SwitchListTile(
                title: const Text(
                  "Dark Mode",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onChanged: (value) {
                  theme.toggleTheme();
                },
                value: theme.darkTheme,
              ),
            ),
            defaultTargetPlatform == TargetPlatform.iOS ||
                    defaultTargetPlatform == TargetPlatform.android
                ? Consumer<LocalAuthenticationService>(
                    builder: (context, localAuthentication, child) =>
                        SwitchListTile(
                      title: const Text(
                        "Biometric Unlock",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onChanged: (value) {
                        localAuthentication.toggleBiometrics();
                      },
                      value: localAuthentication.biometrics,
                    ),
                  )
                : Container(),
            Consumer<InternationalizationService>(
              builder: (context, internationalization, child) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 20, 5),
                  child: Row(children: [
                    Text(
                        LocalizationService.of(context)!
                            .translate('language_label')!,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    DropdownButton<String>(
                      underline: Container(color: Colors.transparent),
                      value: internationalization.selectedItem,
                      onChanged: (String? newValue) {
                        internationalization.changeLanguage(Locale(newValue!));
                      },
                      items: internationalization.languages
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ])),
            ),
            const Divider(
              color: Colors.white,
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Row(children: [
                const Text('Sign Out',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.circleChevronRight,
                  ),
                  onPressed: () {
                    signOut();
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
