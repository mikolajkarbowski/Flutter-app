import 'package:flutter/material.dart';

class AppTheme {
  // Główne kolory
  static final primaryColor =
      const Color(0xFF6A1B9A); // Fioletowy - główny kolor
  static final accentColor =
      const Color(0xFF9C27B0); // Jasny fioletowy - akcent
  static final backgroundColor =
      const Color(0xFFF3E5F5); // Jasny fioletowy beż - tło aplikacji

  // Kolory dla tekstu
  static final headlineColor = Colors.black; // Kolor dla nagłówków
  static final bodyTextColor = Colors.black87; // Kolor tekstu głównego
  static final subTextColor = Colors.black54; // Kolor tekstu pomocniczego

  // Kolory przycisków
  static final buttonColor = accentColor; // Kolor przycisków
  static final disabledButtonColor =
      Colors.grey; // Kolor nieaktywnych przycisków

  // Kolory kart i innych elementów
  static final cardColor = Colors.white; // Kolor kart
  static final cardShadowColor = Colors.black45; // Cień kart

  // Kolory do statusów
  static final errorColor = const Color(0xFFD32F2F); // Kolor błędu
  static final warningColor = const Color(0xFFFFA000); // Kolor ostrzeżenia
  static final successColor = const Color(0xFF388E3C); // Kolor sukcesu

  // Kolory tła
  static final scaffoldBackgroundColor = backgroundColor; // Tło całej aplikacji
  static final appBarColor = primaryColor; // Kolor paska aplikacji

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
    primarySwatch: Colors.purple, // Zmieniony na fioletowy
    primaryColor: primaryColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: appBarColor, // Kolor paska aplikacji
    ),
    textTheme: TextTheme(
      headlineLarge: headlineLarge,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: buttonColor, // Kolor przycisków
      textTheme: ButtonTextTheme.primary,
    ),
    cardTheme: CardTheme(
      color: cardColor, // Kolor kart
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3.0,
      shadowColor: cardShadowColor, // Cień kart
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: primaryColor), // Kolor dla pól tekstowych
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
            color: accentColor), // Kolor dla skupienia na polu tekstowym
      ),
    ),
    hintColor: subTextColor, // Kolor podpowiedzi w polach tekstowych
  );
}
