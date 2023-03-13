
import 'package:flutter/material.dart';

class TimingTheme {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: ColorTheme.primary,
      secondary: ColorTheme.secondary,
      surface: ColorTheme.primary,
      background: ColorTheme.background,
      error: ColorTheme.primary,
      onPrimary: ColorTheme.primaryDark,
      onSecondary: ColorTheme.secondaryDark,
      onSurface: ColorTheme.primary,
      onBackground: ColorTheme.primary,
      onError: ColorTheme.primary,
      brightness: Brightness.light,
    ),
    primaryColor: const Color(0xFFFFD771),
    primaryColorDark: const Color(0xFFE6B74A),
    primaryColorLight: const Color(0xFFFFEBA3),
    highlightColor: const Color(0xFFFFD771),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Pretendard',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 24.0),
      headlineMedium: TextStyle(fontSize: 16.0),
      headlineSmall: TextStyle(fontSize: 12.0),
      bodyLarge: TextStyle(fontSize: 24.0),
      bodyMedium: TextStyle(fontSize: 16.0),
      bodySmall: TextStyle(fontSize: 12.0),
      labelLarge: TextStyle(fontSize: 24.0),
      labelMedium: TextStyle(fontSize: 16.0),
      labelSmall: TextStyle(fontSize: 12.0),
      displayLarge: TextStyle(fontSize: 24.0),
      displayMedium: TextStyle(fontSize: 16.0),
      displaySmall: TextStyle(fontSize: 12.0),
      titleLarge: TextStyle(fontSize: 24.0),
      titleMedium: TextStyle(fontSize: 16.0),
      titleSmall: TextStyle(fontSize: 12.0),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Pretendard',
    textTheme: const TextTheme(
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xFFFFD771),
    ),
  );
}

class ColorTheme {
  static const Color primary = Color(0xFFFFD771);
  static const Color primaryDark = Color(0xFF17171B);
  static const Color primaryLight = Color(0xFFFFF5B1);

  static const Color secondary = Color(0xFF7C4DFF);
  static const Color secondaryDark = Color(0xFF5C2ECC);
  static const Color secondaryLight = Color(0xFFA17CFF);

  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF000000);

  static const Color bottomNaviBgDark = Color(0xFF17171B);

  static const Color inactiveIcon = Color(0xFFBDBDBD);
  static const Color inactiveIconDark = Color(0xFF62626C);

  static const Color activeIcon = Color(0xFF1A1E27);
  static const Color activeIconDark = Color(0xFFFFFFFF);

  static const Color stroke = Color(0xFFE5E8EB);

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color line = Color(0xFFE5E8EB);
}
