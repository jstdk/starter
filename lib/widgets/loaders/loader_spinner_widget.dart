import 'package:flutter/material.dart';

class LoaderSpinnerWidget extends StatelessWidget {
  const LoaderSpinnerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
              child: SizedBox(
            height: 50.0,
            width: 50.0,
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onBackground)),
          )),
        ],
      ),
    );
  }
}
