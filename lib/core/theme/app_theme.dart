import 'package:flutter/material.dart';

class AppTheme {
  // Główne kolory
  static const primaryColor = Color(0xff9a62de);
  static const accentColor = Color(0xFF2742b0);
  static const backgroundColor = Color(0xffc2abde);

  // Kolory dla tekstu
  static const headlineColor = Colors.black;
  static const bodyTextColor = Colors.black87;
  static const subTextColor = Colors.black54;

  // Kolory przycisków
  static const buttonColor = accentColor;
  static const disabledButtonColor = Colors.grey;

  // Kolory kart i innych elementów
  static const cardColor = Colors.white;
  static const cardShadowColor = Colors.black45;

  // Kolory kart fiszek
  static const flashcardFrontColor = Color(0xFFBBDEFB);
  static const flashcardBackColor = Color(0xFFC8E6C9);

  // Kolory do statusów
  static const errorColor = Color(0xFFD32F2F);
  static const warningColor = Color(0xFFFFA000);
  static const successColor = Color(0xFF388E3C);

  // Kolory tła
  static const scaffoldBackgroundColor = backgroundColor;
  static const appBarColor = primaryColor;

  // Stylizacja tekstu
  static const headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: headlineColor,
  );

  static const bodyLarge = TextStyle(
    fontSize: 16,
    color: bodyTextColor,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    color: subTextColor,
  );

  // Główny motyw aplikacji
  static final ThemeData appTheme = ThemeData(
    primarySwatch: Colors.purple,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: appBarColor,
    ),
    textTheme: const TextTheme(
      headlineLarge: headlineLarge,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: buttonColor,
      textTheme: ButtonTextTheme.primary,
    ),
    cardTheme: CardTheme(
      color: cardColor,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      shadowColor: cardShadowColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentColor),
      ),
    ),
    hintColor: subTextColor,
  );
}
