import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxService {
  static const _key = 'isDarkMode';
  final GetStorage _box;

  final RxBool _isDark = false.obs;

  ThemeService(this._box) {
    _isDark.value = _box.read(_key) ?? false;
  }

  bool get isDarkMode => _isDark.value;

  RxBool get rxIsDark => _isDark;

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    final newVal = !_isDark.value;
    _isDark.value = newVal;
    _box.write(_key, newVal);
    Get.changeThemeMode(newVal ? ThemeMode.dark : ThemeMode.light);
  }

  ThemeData get lightTheme {
    const primaryColor = Color(0xFF274668);
    const textColor = Color(0xFF274668);

    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: primaryColor,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: Color(0xFF274668),
        background: Colors.white,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: primaryColor,
        onSurface: primaryColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        titleLarge: TextStyle(color: textColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: primaryColor.withOpacity(0.5),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return null;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return null;
        }),
      ),
    );
  }

  ThemeData get darkTheme {
    const primary = Color(0xFF6FA8DC);
    const bg = Color(0xFF0E1625);
    const surface = Color(0xFF162033);
    const textPrimary = Color(0xFFE6EDF5);
    const textSecondary = Color(0xFF9FB2C8);
    const nevy = Color(0xFF274668);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: bg,

      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        foregroundColor: textPrimary,
        iconTheme: IconThemeData(color: textPrimary),
      ),

      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: Color(0xFF9CC4E4),
        background: bg,
        surface: surface,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onBackground: textPrimary,
        onSurface: textPrimary,
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textPrimary),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        labelMedium: TextStyle(color: textSecondary),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
      ),
    );
  }
}
