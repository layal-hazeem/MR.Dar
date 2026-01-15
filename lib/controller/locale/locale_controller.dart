import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../apartment_controller.dart';
import '../my_apartments_controller.dart';
import '../my_rents_controller.dart' show MyRentsController;

class LocaleController extends GetxController {
  final _storage = GetStorage();
  final String _localeKey = 'app_locale';

  RxString currentLocale = 'ar'.obs;

  @override
  void onInit() {
    super.onInit();
    final savedLocale = _storage.read(_localeKey);
    if (savedLocale != null) {
      currentLocale.value = savedLocale;
      Get.updateLocale(Locale(savedLocale));
    }
  }

  void changeLocale(String newLocale) {
    currentLocale.value = newLocale;
    Get.updateLocale(Locale(newLocale));
    _storage.write(_localeKey, newLocale);

    _refreshDataAfterLanguageChange();
  }

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
