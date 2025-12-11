// lib/core/theme/theme_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxService {
  static const _key = 'isDarkMode';
  final GetStorage _box;

  // Rx -> لنقدر نستخدم Obx لتحديث الأيقونة فوراً
  final RxBool _isDark = false.obs;

  ThemeService(this._box) {
    // عند الإنشاء نحمّل القيمة المخزنة
    _isDark.value = _box.read(_key) ?? false;
  }

  // getter للسمة الحالية
  bool get isDarkMode => _isDark.value;

  // Stream / observable لو حبيت تراقب
  RxBool get rxIsDark => _isDark;

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  // Toggle مع حفظ القيمة
  void toggleTheme() {
    final newVal = !_isDark.value;
    _isDark.value = newVal;
    _box.write(_key, newVal);
    // يغير ثيم التطبيق فوراً
    Get.changeThemeMode(newVal ? ThemeMode.dark : ThemeMode.light);
  }

  // تعطي ThemeData جاهزين — عدلي القيم حسب ذوقك
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF274668), // لونك الأساسي
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF96C6E2),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF274668),
        secondary: const Color(0xFF96C6E2),
        background: Colors.white,
        surface: const Color(0xFFE5E8EF),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.black87,
        onSurface: Colors.black87,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFDFEEF6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF274668),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF274668),
      scaffoldBackgroundColor: const Color(0xFF0B1220),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF12233A),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF274668),
        secondary: const Color(0xFF96C6E2),
        background: const Color(0xFF0B1220),
        surface: const Color(0xFF0F1724),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1F2937),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF274668),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
