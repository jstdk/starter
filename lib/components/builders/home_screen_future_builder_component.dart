import 'package:flutter/material.dart';

import '../../models/profile.dart';
import '../../screens/private/home_screen.dart';
import '../../services/localization_service.dart';
import '../../services/user_service.dart';
import '../loaders/loader_spinner_component.dart';

class HomeScreenFutureBuilderComponent extends StatelessWidget {
  const HomeScreenFutureBuilderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
                    LocalizationService.of(context)
                            ?.translate('general_error_snackbar_label') ??
                        '',
                    style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.onBackground)));
          } else if (snapshot.hasData) {
            final ProfileModel profile = snapshot.data!;
            return HomeScreen(profile: profile);
          }
        }
        return const LoaderSpinnerComponent();
      },
      future: UserService().loadProfile(),
    );
  }
}
