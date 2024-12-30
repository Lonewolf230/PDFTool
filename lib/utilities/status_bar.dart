import 'package:flutter/services.dart';

void hideStatusBar() {
  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive // Only the navigation bar is visible
      );
}

void showStatusBar() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}
