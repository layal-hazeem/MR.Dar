import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class signupController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  var birthDate = "".obs;

  void setBirthDate(String date) {
    birthDate.value = date;
    update();
  }

  bool validateSignup() {
    if (formKey.currentState!.validate()) {
      if (birthDate.value.isEmpty) {
        Get.snackbar(
          "Error",
          "Please choose Date of Birth",
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
      return true;
    }
    return false;
  }
}
