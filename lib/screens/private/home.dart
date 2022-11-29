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

  Future loadProfile(String id, String email) async {
    profile = ProfileModel.fromMap(
        map: await supabase.from('profiles').select().eq('id', id).single(),
        emailFromAuth: email);
  }

  @override
  void dispose() {
    super.dispose();
  }

  leftSection() {
    return ResponsiveRowColumnItem(
        child: ResponsiveVisibility(
      hiddenWhen: const [Condition.smallerThan(name: TABLET)],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
            child: Row(
              children: [
                const Text('Open'),
                SizedBox(
                  child: Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  middleSection(messages) {
    return ResponsiveRowColumnItem(
      rowFlex: 2,
      child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return Card(
                // In many cases, the key isn't mandatory
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(message.content!),
                ));
          }),
    );
  }

  rightSection() {
    return ResponsiveRowColumnItem(
        rowFlex: 1,
        child: ResponsiveVisibility(
          hiddenWhen: const [Condition.smallerThan(name: TABLET)],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                  child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: const [
                    Text('YEAHHHHH'),
                  ],
                ),
              )),
              const SizedBox(
                width: 300,
              )
            ],
          ),
        ));
  }

  mainSection() {
    return SizedBox(
      width: double.infinity,
      height: double.maxFinite,
      child: StreamBuilder<List<MessageModel>>(
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
                  rowMainAxisAlignment: MainAxisAlignment.start,
                  rowCrossAxisAlignment: CrossAxisAlignment.start,
                  rowPadding: const EdgeInsets.all(20),
                  columnPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  children: [
                    leftSection(),
                    middleSection(messages),
                    rightSection(),
                  ]);
            } else {
              return Text(LocalizationService.of(context)
                      ?.translate('no_data_message') ??
                  '');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }

  drawer() {
    return const Drawer(child: Text('Text'));
  }

  endDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
            child: Text(
                LocalizationService.of(context)?.translate('settings_header') ??
                    ''),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
            child: Row(children: [
              Text(
                  LocalizationService.of(context)?.translate('profile_link') ??
                      '',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
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
              title: Text(
                LocalizationService.of(context)
                        ?.translate('dark_mode_switcher') ??
                    '',
                style: const TextStyle(fontWeight: FontWeight.bold),
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
                    title: Text(
                      LocalizationService.of(context)
                              ?.translate('biometrics_switcher') ??
                          '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                          .translate('language_dropdown')!,
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
              Text(
                  LocalizationService.of(context)?.translate('sign_out_link') ??
                      '',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.circleChevronRight,
                ),
                onPressed: () async {
                  await signOut();
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ResponsiveVisibility(
                visible: false,
                visibleWhen: const [Condition.smallerThan(name: TABLET)],
                child: Builder(builder: (context) {
                  return IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.chevronRight,
                      size: 20.0,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                }),
              ),
              ResponsiveVisibility(
                visible: true,
                hiddenWhen: const [Condition.smallerThan(name: TABLET)],
                child: Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                    child: TextButton(
                      child: Text(
                        LocalizationService.of(context)
                                ?.translate('brand_header') ??
                            '',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          ResponsiveVisibility(
            visible: false,
            visibleWhen: const [Condition.largerThan(name: MOBILE)],
            child: Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextButton(
                  child: Text(
                    LocalizationService.of(context)
                            ?.translate('settings_header') ??
                        '',
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              );
            }),
          ),
          ResponsiveVisibility(
            visible: false,
            visibleWhen: const [Condition.smallerThan(name: TABLET)],
            child: Builder(
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [mainSection()],
        ),
      ),
      drawer: drawer(),
      endDrawer: endDrawer(),
    );
  }
}
