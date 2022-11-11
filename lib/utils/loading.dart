import 'package:flutter/material.dart';

class LoadingUtil extends StatelessWidget {
  const LoadingUtil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
