import 'package:flutter/material.dart';

class AppTheme {
  // Główne kolory
  static final primaryColor = const Color(0xff9a62de);
  static final accentColor = const Color(0xFF2742b0);
  static final backgroundColor = Color(0xffc2abde);

  // Kolory dla tekstu
  static final headlineColor = Colors.black;
  static final bodyTextColor = Colors.black87;
  static final subTextColor = Colors.black54;

  // Kolory przycisków
  static final buttonColor = accentColor;
  static final disabledButtonColor = Colors.grey;

  // Kolory kart i innych elementów
  static final cardColor = Colors.white;
  static final cardShadowColor = Colors.black45;

  // Kolory kart fiszek
  static final flashcardFrontColor = const Color(0xFFBBDEFB);
  static final flashcardBackColor = const Color(0xFFC8E6C9);

  // Kolory do statusów
  static final errorColor = const Color(0xFFD32F2F);
  static final warningColor = const Color(0xFFFFA000);
  static final successColor = const Color(0xFF388E3C);

  // Kolory tła
  static final scaffoldBackgroundColor = backgroundColor;
  static final appBarColor = primaryColor;

  // Stylizacja tekstu
  static final headlineLarge = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: headlineColor,
  );

  static final bodyLarge = TextStyle(
    fontSize: 16.0,
    color: bodyTextColor,
  );

  static final bodyMedium = TextStyle(
    fontSize: 14.0,
    color: subTextColor,
  );

  // Główny motyw aplikacji
  static final ThemeData appTheme = ThemeData(
    primarySwatch: Colors.purple,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: appBarColor,
    ),
    textTheme: TextTheme(
      headlineLarge: headlineLarge,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: buttonColor,
      textTheme: ButtonTextTheme.primary,
    ),
    cardTheme: CardTheme(
      color: cardColor,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3.0,
      shadowColor: cardShadowColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: accentColor),
      ),
    ),
    hintColor: subTextColor,
  );
}
