import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';

class UndoResetLinkWidget extends StatelessWidget {
  const UndoResetLinkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FormService>(
        builder: (context, form, child) => GestureDetector(
            child: Text(
                LocalizationService.of(context)
                        ?.translate('go_back_home_link_label') ??
                    '',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              form.toggleReset();
            }));
  }
}
