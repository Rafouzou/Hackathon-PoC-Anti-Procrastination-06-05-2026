import 'package:flutter/material.dart';

class VerifiColors {
  static const Color yellow = Color(0xFFFFC300);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGrey = Color(0xFF1A1A1A);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color border = Color(0xFFE0E0E0);
  static const Color primary = Color(0xFFFFC300);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color text = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF666666);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
}

class VerifiTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: VerifiColors.yellow,
      scaffoldBackgroundColor: VerifiColors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: VerifiColors.yellow,
        foregroundColor: VerifiColors.black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _titleLarge(),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: VerifiColors.yellow,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: VerifiColors.yellow,
          foregroundColor: VerifiColors.black,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: _buttonText(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: VerifiColors.black,
          side: const BorderSide(color: VerifiColors.black, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: _buttonText(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: VerifiColors.lightGrey,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: VerifiColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: VerifiColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: VerifiColors.yellow, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: VerifiColors.error),
        ),
  labelStyle: _bodyText(),
        hintStyle: _bodyText().copyWith(color: VerifiColors.darkGrey.withValues(alpha: 0.5)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: VerifiColors.white,
        selectedItemColor: VerifiColors.yellow,
        unselectedItemColor: VerifiColors.darkGrey,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: TextTheme(
        displayLarge: _displayLarge(),
        displayMedium: _displayMedium(),
        headlineSmall: _headlineSmall(),
        titleLarge: _titleLarge(),
        titleMedium: _titleMedium(),
        bodyLarge: _bodyLarge(),
        bodyMedium: _bodyText(),
        bodySmall: _bodySmall(),
      ),
    );
  }

  // Typography
  static TextStyle _displayLarge() => const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: VerifiColors.black,
    fontFamily: 'Poppins',
  );

  static TextStyle _displayMedium() => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: VerifiColors.black,
    fontFamily: 'Poppins',
  );

  static TextStyle _headlineSmall() => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: VerifiColors.black,
    fontFamily: 'Poppins',
  );

  static TextStyle _titleLarge() => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: VerifiColors.black,
    fontFamily: 'Poppins',
  );

  static TextStyle _titleMedium() => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: VerifiColors.black,
    fontFamily: 'Poppins',
  );

  static TextStyle _bodyLarge() => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: VerifiColors.black,
    fontFamily: 'Inter',
  );

  static TextStyle _bodyText() => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: VerifiColors.black,
    fontFamily: 'Inter',
  );

  static TextStyle _bodySmall() => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: VerifiColors.darkGrey,
    fontFamily: 'Inter',
  );

  static TextStyle _buttonText() => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );
}

// Spacing constants
class VerifiSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

// Border radius constants
class VerifiRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double xlarge = 24;
}
