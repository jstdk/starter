import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

import '../../utils/loading.dart';
import '../../utils/theme.dart';
import '../../utils/local_authentication.dart';

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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          //actions: [
          //  ValueListenableBuilder(
          //    valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
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
              return const Loading();
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
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              Consumer<ThemeUtil>(
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
                  ? Consumer<LocalAuthenticationUtil>(
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

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// final supabase = Supabase.instance.client;

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool loading = false;

//   final double breakpoint = 600;
//   final int paneProportion = 70;

//   Future<void> signOut() async {
//     try {
//       await supabase.auth.signOut();
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }

//   Future getData() async {
//     try {
//       final data = await supabase.from('entries').select();
//       print(data);
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     //getData();
//     supabase
//         .from('entries')
//         .stream(primaryKey: ['id']).listen((List<Map<String, dynamic>> data) {
//       // Do something awesome with the data
//       print(data);
//     });

//     supabase.channel('public:entries').on(
//       RealtimeListenTypes.postgresChanges,
//       ChannelFilter(event: '*', schema: 'public', table: 'entries'),
//       (payload, [ref]) {
//         print('Change received: ${payload.toString()}');
//       },
//     ).subscribe();

//     return Scaffold(
//         body: Column(
//       children: [
//         const SizedBox(height: 20),
//         ElevatedButton(
//           child: const Text(
//             "Set Theme",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           onPressed: () async {
//             Get.changeTheme(Get.isDarkMode
//                 ? ThemeData.light()
//                 : ThemeData
//                     .dark()); //AdaptiveTheme.of(context).toggleThemeMode();
//           },
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           child: const Text(
//             "Sign out",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           onPressed: () async {
//             signOut();
//           },
//         ),
//       ],
//     ));

// return loading
//     ? const Loading()
//     : Scaffold(
//         appBar: AppBar(
//           leading: Builder(
//             builder: (context) {
//               return IconButton(
//                 icon: const Icon(
//                   Icons.menu_rounded,
//                 ),
//                 onPressed: () {
//                   Scaffold.of(context).openDrawer();
//                 },
//               );
//             },
//           ),
//           title: const Text('Commit',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               )),
//           centerTitle: true,
//           elevation: 0,
//           actions: [
//             IconButton(
//                 icon: const Icon(
//                   Icons.notifications,
//                 ),
//                 onPressed: () {
//                   showMaterialModalBottomSheet(
//                       expand: false,
//                       context: context,
//                       builder: (context) => const SizedBox(
//                           height: 300, child: Text('Notifications')));
//                 }),
//           ],
//         ),
//         body: Scrollbar(
//           child: SingleChildScrollView(
//             child: Column(children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(15, 20, 10, 5),
//                 child: Row(
//                   children: <Widget>[
//                     const Text(
//                       "Commitments",
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Spacer(),
//                     const Text(
//                       "Sort by",
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Builder(
//                       builder: (context) {
//                         return IconButton(
//                           icon: const Icon(Icons.sort),
//                           onPressed: () {
//                             Scaffold.of(context).openEndDrawer();
//                           },
//                         );
//                       },
//                     )
//                   ],
//                 ),
//               ),
//               commitments.isEmpty
//                   ? const LoadingShare()
//                   : breakpoint > MediaQuery.of(context).size.width
//                       ? SizedBox(
//                           height: double.maxFinite,
//                           width: double.maxFinite,
//                           child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: commitments.length,
//                               itemBuilder:
//                                   (BuildContext context, int index) {
//                                 // return Text(commitmentList[index].description);
//                                 return Dismissible(
//                                   key: ValueKey<String>(
//                                       commitments[index].key),
//                                   background: Container(
//                                     color: Colors.blue,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(15),
//                                       child: Row(
//                                         children: const [
//                                           Icon(Icons.edit,
//                                               color: Colors.white),
//                                           SizedBox(width: 10),
//                                           Text('Edit commitment',
//                                               style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontWeight:
//                                                       FontWeight.bold)),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   secondaryBackground: Container(
//                                     color: Colors.red,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(15),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         children: const [
//                                           Icon(
//                                             Icons.delete,
//                                             color: Colors.white,
//                                           ),
//                                           SizedBox(width: 10),
//                                           Text('Delete commitment',
//                                               style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontWeight:
//                                                       FontWeight.bold)),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   confirmDismiss: (direction) async {
//                                     if (direction ==
//                                         DismissDirection.startToEnd) {
//                                       /// edit item
//                                       showMaterialModalBottomSheet(
//                                           expand: false,
//                                           context: context,
//                                           builder: (context) => SizedBox(
//                                               height: 300,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(
//                                                         15.0),
//                                                 child: EditCommitment(
//                                                   commitmentKey:
//                                                       commitments[index]
//                                                           .key,
//                                                   currentDescription:
//                                                       commitments[index]
//                                                           .description,
//                                                 ),
//                                               )));
//                                       return false;
//                                     } else if (direction ==
//                                         DismissDirection.endToStart) {
//                                       CommitmentService().deleteCommitment(
//                                           commitments[index].key);
//                                       if (kDebugMode) {
//                                         print('Remove commitment');
//                                       }
//                                       return true;
//                                     }
//                                     return null;
//                                   },
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       Get.to(DetailScreen(
//                                           description: commitments[index]
//                                               .description));
//                                     },
//                                     child: Card(
//                                       margin: const EdgeInsets.fromLTRB(
//                                           5, 1, 5, 5),
//                                       child: ListTile(
//                                         // leading: CachedNetworkImage(
//                                         //   imageUrl: "",
//                                         //   placeholder: (context, url) =>
//                                         //       const CircularProgressIndicator(),
//                                         //   errorWidget: (context, url, error) =>
//                                         //       const Icon(Icons.error),
//                                         // ),
//                                         title: Text(
//                                           commitments[index].description,
//                                           style: const TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         subtitle: const Text(
//                                           'subtitle.',
//                                           style: TextStyle(
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                               scrollDirection: Axis.vertical))
//                       : SizedBox(
//                           height: double.maxFinite,
//                           width: double.maxFinite,
//                           child: Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: GridView(
//                                 gridDelegate:
//                                     const SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 3,
//                                   crossAxisSpacing: 5,
//                                   mainAxisSpacing: 5,
//                                 ),
//                                 primary: false,
//                                 shrinkWrap: true,
//                                 children: List<Widget>.generate(
//                                     commitments
//                                         .length, // same length as the data
//                                     (index) => GestureDetector(
//                                           onTap: () {
//                                             Get.to(DetailScreen(
//                                                 description:
//                                                     commitments[index]
//                                                         .description));
//                                           },
//                                           child: Card(
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(
//                                                   15.0),
//                                               child: GridTile(
//                                                 footer: Text(
//                                                   commitments[index]
//                                                       .description,
//                                                   style: const TextStyle(
//                                                       fontSize: 13,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                                 child: Text(
//                                                   commitments[index]
//                                                       .description,
//                                                   style: const TextStyle(
//                                                       fontSize: 18,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ), //just for testing, will fill with image later
//                                               ),
//                                             ),
//                                           ),
//                                         ))),
//                           ),
//                         )
//             ]),
//           ),
//         ),
//         drawer: Drawer(
//           child: Column(
//             children: [
//               const SizedBox(height: 100),
//               Container(
//                 alignment: Alignment.topLeft,
//                 child: const Padding(
//                   padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
//                   child: Text(
//                     'Settings',
//                     style: TextStyle(
//                       fontSize: 30,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 100),

//               // SizedBox(
//               //   height: MediaQuery.of(context).size.height * 0.3,
//               //   width: MediaQuery.of(context).size.width,
//               //   child: Stack(
//               //     children: const [
//               //       Positioned(
//               //         top: 30.0,
//               //         left: 90.0,
//               //         child: CircleAvatar(
//               //           radius: 50,
//               //           child: Icon(Icons.person, size: 60, color: Colors.grey),
//               //         ),
//               //       ),
//               //       Positioned(
//               //         child: Text(
//               //           'Username',
//               //           style: TextStyle(
//               //             fontSize: 30,
//               //           ),
//               //         ),
//               //         top: 150,
//               //         left: 60,
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               Consumer<ThemeService>(
//                 builder: (context, theme, child) => SwitchListTile(
//                   title: const Text(
//                     "Dark Mode",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   onChanged: (value) {
//                     theme.toggleTheme();
//                   },
//                   value: theme.darkTheme,
//                 ),
//               ),
//               defaultTargetPlatform == TargetPlatform.iOS ||
//                       defaultTargetPlatform == TargetPlatform.android
//                   ? Consumer<LocalAuthenticationService>(
//                       builder: (context, localAuthentication, child) =>
//                           SwitchListTile(
//                         title: const Text(
//                           "Biometric Unlock",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         onChanged: (value) {
//                           localAuthentication.toggleBiometrics();
//                         },
//                         value: localAuthentication.biometrics,
//                       ),
//                     )
//                   : Container(),
//               const Divider(
//                 color: Colors.white,
//               ),
//               const SizedBox(height: 15),
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
//                     child: SizedBox(
//                       width: 100,
//                       child: ElevatedButton(
//                         child: const Text(
//                           "Log out",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         onPressed: () async {
//                           setState(() => loading = true);
//                           UserService().signOut().then((result) {
//                             setState(() => loading = false);
//                             Get.to(const Authorization());
//                           });
//                         },
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//         endDrawer: Drawer(
//           child: Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: const [
//                     SizedBox(height: 50),
//                     Text(
//                       'Sort',
//                       style: TextStyle(
//                         fontSize: 30,
//                       ),
//                     ),
//                     SizedBox(height: 50),
//                     Text(
//                       'Sort',
//                       style: TextStyle(
//                         fontSize: 20,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: const Icon(Icons.add), //child widget inside this button
//           onPressed: () {
//             showMaterialModalBottomSheet(
//                 expand: false,
//                 context: context,
//                 builder: (context) =>
//                     const SizedBox(height: 300, child: NewCommitment()));
//           },
//         ),
//       );
//   }
// }
