import 'package:flutter/material.dart';

class ThemeHelper {
  static bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}
