import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator.adaptive(
            backgroundColor: Colors.green,
          ),
          Text(
            'Creating Pdf please wait',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
