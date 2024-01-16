import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:thessariakos/helpers/language_helper.dart';
import 'package:thessariakos/screens/welcome_screen.dart';
import 'package:thessariakos/themes/day_theme.dart';
import 'package:thessariakos/themes/night_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: LanguageHelper.getAvailableLocales(),
      // Define the supported locales
      path: 'assets/translations',
      // Specify the path where your translation files are located
      fallbackLocale: LanguageHelper.getAvailableLocales().first,
      // Set a fallback locale
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomeScreen(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: DayTheme.getTheme(),
      darkTheme: NightTheme.getTheme(),
      themeMode: ThemeMode.system,
    );
  }
}
