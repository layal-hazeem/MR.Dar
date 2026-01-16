import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/locale/locale_controller.dart';

void showLanguageSelector(BuildContext context) {
  final LocaleController controller = Get.find<LocaleController>();

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Change app language".tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),

          ListTile(
            leading: const Text("🇸🇾", style: TextStyle(fontSize: 22)),
            title: Text(
              "العربية",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            trailing: Get.locale?.languageCode == 'ar'
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () {
              controller.changeLocale('ar');
              Get.back();
            },
          ),

          ListTile(
            leading: const Text("🇬🇧", style: TextStyle(fontSize: 22)),
            title: Text(
              "English",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            trailing: Get.locale?.languageCode == 'en'
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () {
              controller.changeLocale('en');
              Get.back();
            },
          ),
        ],
      ),
    ),
  );
}
