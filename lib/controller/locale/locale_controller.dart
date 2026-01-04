// lib/controller/locale/locale_controller.dart
import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../ApartmentController.dart';
import '../my_apartments_controller.dart';
import '../my_rents_controller.dart' show MyRentsController;

class LocaleController extends GetxController {
  final _storage = GetStorage();
  final String _localeKey = 'app_locale';

  // القيمة الافتراضية
  RxString currentLocale = 'ar'.obs;

  @override
  void onInit() {
    super.onInit();
    // جلب اللغة المحفوظة عند بدء التطبيق
    final savedLocale = _storage.read(_localeKey);
    if (savedLocale != null) {
      currentLocale.value = savedLocale;
      Get.updateLocale(Locale(savedLocale));
    }
  }

  // تغيير اللغة
  void changeLocale(String newLocale) {
    currentLocale.value = newLocale;
    Get.updateLocale(Locale(newLocale));
    _storage.write(_localeKey, newLocale); // حفظ في التخزين المحلي

    /// 🔥 أهم سطر
    _refreshDataAfterLanguageChange();
  }

  // تبديل بين العربية والإنجليزية
  void toggleLocale() {
    if (currentLocale.value == 'ar') {
      changeLocale('en');
    } else {
      changeLocale('ar');
    }
  }

  void _refreshDataAfterLanguageChange() {
    // أي Controller بيجيب بيانات من الباك
    if (Get.isRegistered<ApartmentController>()) {
      Get.find<ApartmentController>().reload();
    }

    if (Get.isRegistered<MyApartmentsController>()) {
      Get.find<MyApartmentsController>().reload();
    }

    if (Get.isRegistered<MyRentsController>()) {
      Get.find<MyRentsController>().reload();
    }
  }
}