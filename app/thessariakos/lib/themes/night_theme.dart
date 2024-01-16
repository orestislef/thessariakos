import 'package:flutter/material.dart';

class NightTheme {
  static ThemeData getTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blueGrey,
      appBarTheme: NightTheme.getAppBarTheme(),
      tabBarTheme: NightTheme.getTabBarTheme(),
      floatingActionButtonTheme: NightTheme.getFloatingActionButtonTheme(),
    );
  }

  static AppBarTheme getAppBarTheme() {
    return const AppBarTheme(
      titleSpacing: 2.0,
      color: Colors.blueGrey,
      centerTitle: true,
    );
  }

  static TabBarTheme getTabBarTheme() {
    return const TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Colors.white, width: 2.0),
      ),
      labelStyle: TextStyle(fontSize: 20.0),
      unselectedLabelStyle: TextStyle(fontSize: 16.0),
      indicatorSize: TabBarIndicatorSize.tab,
    );
  }

  static FloatingActionButtonThemeData getFloatingActionButtonTheme() {
    return const FloatingActionButtonThemeData(
      backgroundColor: Colors.white54,
      foregroundColor: Colors.black,
      elevation: 5.0,
      highlightElevation: 10.0,
      splashColor: Colors.blueGrey,
      enableFeedback: true,
      shape: CircleBorder(),
      focusColor: Colors.blueGrey,
      hoverColor: Colors.blueGrey,
    );
  }
}
