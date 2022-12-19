import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';

class AvatarFormFieldWidget extends StatefulWidget {
  final Uint8List? avatarBytes;
  const AvatarFormFieldWidget({super.key, this.avatarBytes});

  @override
  State<AvatarFormFieldWidget> createState() => _AvatarFormFieldWidgetState();
}

class _AvatarFormFieldWidgetState extends State<AvatarFormFieldWidget> {
  bool loading = false;

  dynamic tempFile;
  XFile? avatarFile;

  dynamic avatarAsBytes;
  String? base64Avatar;
  Uint8List? avatarBytes;
  final ImagePicker _picker = ImagePicker();

  Future pickAvatar(camera) async {
    Navigator.pop(context);
    avatarFile = await _picker.pickImage(
        source: camera == true ? ImageSource.camera : ImageSource.gallery,
        maxHeight: 480,
        maxWidth: 640);
    if (avatarFile != null) {
      setState(() => {loading = true});
    }
    avatarAsBytes = await avatarFile!.readAsBytes();
    base64Avatar = base64Encode(avatarAsBytes);
    setState(() => {
          loading = false,
          FormService.avatarBytes = base64Decode(base64Avatar!)
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 200.0,
          child: avatarBytes != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(avatarBytes!))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(widget.avatarBytes!)),
        ),
        const SizedBox(height: 20),
        TextButton(
            onPressed: () => {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: SimpleDialog(
                          title: Center(
                              child: Text(kIsWeb
                                  ? LocalizationService.of(context)
                                          ?.translate('select_avatar_label') ??
                                      ''
                                  : LocalizationService.of(context)?.translate(
                                          'make_select_avatar_label') ??
                                      '')),
                          children: <Widget>[
                            Row(
                              children: [
                                const Spacer(),
                                kIsWeb
                                    ? Container()
                                    : IconButton(
                                        icon: const Icon(
                                          FontAwesomeIcons.cameraRetro,
                                          size: 20.0,
                                        ),
                                        onPressed: () async {
                                          await pickAvatar(true);
                                        },
                                      ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(
                                    FontAwesomeIcons.image,
                                    size: 20.0,
                                  ),
                                  onPressed: () async {
                                    await pickAvatar(false);
                                  },
                                ),
                                const Spacer()
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )
                },
            child: Text(
                LocalizationService.of(context)
                        ?.translate('change_avatar_button_label') ??
                    '',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground)))
      ],
    );
  }
}
