import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/localization_service.dart';

class AvatarFormFieldComponent extends StatefulWidget {
  final Uint8List? avatarBytes;
  const AvatarFormFieldComponent({super.key, this.avatarBytes});

  @override
  State<AvatarFormFieldComponent> createState() =>
      _AvatarFormFieldComponentState();
}

class _AvatarFormFieldComponentState extends State<AvatarFormFieldComponent> {
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
    setState(
        () => {loading = false, avatarBytes = base64Decode(base64Avatar!)});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      width: 200.0,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          avatarBytes != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(avatarBytes!))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(widget.avatarBytes!)),
          Positioned(
              bottom: -15,
              right: -15,
              child: RawMaterialButton(
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
                elevation: 2.0,
                fillColor: Theme.of(context).colorScheme.onBackground,
                padding: const EdgeInsets.all(8.0),
                shape: const CircleBorder(),
                child: Icon(
                  FontAwesomeIcons.camera,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )),
        ],
      ),
    );
  }
}
