import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/theme.dart';
import '../../services/local_authentication.dart';
import '../../services/internationalization.dart';
import '../../services/localization.dart';

final supabase = Supabase.instance.client;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  final data = supabase.from('entries').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    // Initial Selected Value
    String dropdownvalue = 'en';

    // List of items in our dropdown menu
    var items = [
      'en',
      'nl',
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text(LocalizationService.of(context)!.translate('title')!),
          centerTitle: true,
          //actions: [
          //  ValueListenableBuilder(
          //    valueListenable: AdaptiveTheme.of(conte:widthxt).modeChangeNotifier,
          //    builder: (_, mode, child) {
          //      return mode != AdaptiveThemeMode.dark
          //          ? IconButton(
          //              icon: const Icon(FontAwesomeIcons.moon),
          //              onPressed: () async {
          //                AdaptiveTheme.of(context).setDark();
          //              })
          //          : IconButton(
          //              icon: const Icon(FontAwesomeIcons.sun),
          //              onPressed: () async {
          //                AdaptiveTheme.of(context).setLight();
          //              });
          //    },
          //  ),
          //],
        ),
        body: StreamBuilder(
          stream: data,
          builder: (
            context,
            snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
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
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: (snapshot.data as List).length,
                            // display each item of the product list
                            itemBuilder: (context, index) {
                              return Card(
                                  // In many cases, the key isn't mandatory
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 15),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text((snapshot.data as List)[index]
                                        ['entry']),
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
        drawer: Drawer(
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
                  builder: (context, internationalization, child) =>
                      DropdownButton(
                        value: dropdownvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                            internationalization
                                .changeLanguage(Locale(newValue));
                          });
                        },
                      )),
              const Divider(
                color: Colors.white,
              ),
              const SizedBox(height: 50),
              ListTile(
                title: const Text('Sign out'),
                onTap: () {
                  signOut();
                },
              ),
            ],
          ),
        ));
  }
}
