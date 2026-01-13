import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../core/api/api_config.dart';
import '../core/bindings/app_bindings.dart';
import '../core/storage/app_storage.dart';
import 'Splash.dart';
import 'home.dart';

class BaseUrlPage extends StatelessWidget {
  BaseUrlPage({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter API Base URL",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "http://192.168.1.106:8000/api/",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final url = controller.text.trim();

                ApiConfig.baseUrl = url;
                await AppStorage.saveBaseUrl(url);

                AppBindings().dependencies();

                Get.offAll(() => Splash());
              },
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
