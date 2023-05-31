import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData getAppTheme() {
  return ThemeData(
    primaryColor: const Color.fromARGB(132, 45, 56, 180), // Primary color for app bars, buttons, etc.
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF00C853)), // Secondary color for focused controls, highlighted text, etc.
    scaffoldBackgroundColor: Colors.white, // Background color for app screens
    
    // Typography
    fontFamily: 'Roboto', // Default font family
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), // Headline text style
      titleMedium: TextStyle(fontSize: 16.0), // Subtitle text style
      bodyMedium: TextStyle(fontSize: 14.0), // Body text style
    ),

    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true, // Enable background color for input fields
      fillColor: const Color(0xFFF5F5F5), // Input field background color
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0), // Input field border radius
      ),
    ),

    // Buttons
    buttonTheme: ButtonThemeData(
      buttonColor: const Color(0xFF1A237E), // Default button color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0), // Button border radius
      ),
    ),

    // App bar
    appBarTheme: const AppBarTheme(
      color: Color(0xFF1A237E), // App bar color
      systemOverlayStyle: SystemUiOverlayStyle.dark, // Dark theme for app bar
    ),

    // Bottom navigation bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1A237E), // Bottom navigation bar background color
      selectedItemColor: Colors.white, // Selected item color
      unselectedItemColor: Colors.grey, // Unselected item color
    )
  );
}