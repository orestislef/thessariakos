import 'package:flutter/material.dart';

class DayTheme {
  static ThemeData getTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blueGrey,
      appBarTheme: DayTheme.getAppBarTheme(),
      tabBarTheme: DayTheme.getTabBarTheme(),
      floatingActionButtonTheme: DayTheme.getFloatingActionButtonTheme(),
    );
  }

  static AppBarTheme getAppBarTheme() {
    return const AppBarTheme(
      backgroundColor: Colors.blueGrey,
      centerTitle: true,
    );
  }

  static TabBarTheme getTabBarTheme() {
    return const TabBarTheme(
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Colors.black, width: 2.0),
      ),
      labelStyle: TextStyle(fontSize: 20.0),
      unselectedLabelStyle: TextStyle(fontSize: 16.0),
      indicatorSize: TabBarIndicatorSize.tab,
    );
  }

  static FloatingActionButtonThemeData getFloatingActionButtonTheme() {
    return const FloatingActionButtonThemeData(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
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
