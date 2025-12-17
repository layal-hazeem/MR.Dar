import 'package:get/get.dart';
import '../service/auth_service.dart';

import '../view/WelcomePage.dart';

class AuthController extends GetxController {
  final AuthService authService;

  AuthController({required this.authService});

  Future<void> logout() async {
    await authService.signOut();

    Get.offAll(() => const WelcomePage());
  }
}
