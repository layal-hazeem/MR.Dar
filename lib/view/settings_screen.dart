import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/my_account_controller.dart';
import '../controller/auth_controller.dart';
import '../core/theme/theme_service.dart';
import 'language_selector_dialog.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final MyAccountController accountController = Get.find<MyAccountController>();
  final AuthController authController = Get.find<AuthController>();
  final ThemeService themeService = Get.find<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings".tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: ListView(
        children: [
          _sectionTitle(context, "Preferences".tr),

          settingsCard(
            context: context,
            icon: Icons.dark_mode,
            title: "Theme".tr,
            subtitle: "Light / Dark mode".tr,
            onTap: () => _showThemeBottomSheet(context),
          ),

          settingsCard(
            context: context,
            icon: Icons.language,
            title: "Language".tr,
            subtitle: "Change app language".tr,
            onTap: () => showLanguageSelector(context),
          ),
        ],
      ),
    );
  }

  Widget settingsCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Color? textColor,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: enabled
                    ? iconColor ?? Theme.of(context).iconTheme.color
                    : Theme.of(context).disabledColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: enabled
                            ? textColor ??
                                  Theme.of(context).textTheme.bodyMedium?.color
                            : Theme.of(context).disabledColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (enabled) const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(
            context,
          ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() {
          final isDark = themeService.rxIsDark.value;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Text(
                "Choose Theme".tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              ListTile(
                leading: const Icon(Icons.light_mode),
                title: Text("Light Mode".tr),
                trailing: !isDark
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  if (isDark) {
                    themeService.toggleTheme();
                  }
                  Get.back();
                },
              ),

              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: Text("Dark Mode".tr),
                trailing: isDark
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  if (!isDark) {
                    themeService.toggleTheme();
                  }
                  Get.back();
                },
              ),

              const SizedBox(height: 12),
            ],
          );
        }),
      ),
      isScrollControlled: false,
    );
  }
}
