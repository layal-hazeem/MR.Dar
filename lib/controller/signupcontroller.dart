import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../core/errors/exceptions.dart';
import '../service/auth_service.dart';
import '../view/home.dart';
import 'package:new_project/core/api/dio_consumer.dart';

class SignupController extends GetxController {
  final AuthService api;
  SignupController({required this.api});

  Rx<XFile?> profileImage = Rx<XFile?>(null);
  Rx<XFile?> idImage = Rx<XFile?>(null);
  RxString birthDate = "".obs;
  RxInt role = 0.obs;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  bool isPasswordHidden = true;
  bool isConfirmHidden = true;

  @override
  void onInit() {
    super.onInit();
  }

  void toggleConfirmPassword() {
    isConfirmHidden = !isConfirmHidden;
    update();
  }

  final ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  void togglePassword() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  // اختيار صورة Profile من Camera أو Gallery
  void selectProfileImage() {
    Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Gallery"),
            onTap: () async {
              Get.back();
              final XFile? image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) {
                profileImage.value = image;
                update();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: () async {
              Get.back();
              final XFile? image = await picker.pickImage(
                source: ImageSource.camera,
              );
              if (image != null) {
                profileImage.value = image;
                update();
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  // اختيار صورة ID
  void pickIdImage() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        idImage.value = image;
        update();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick ID image: $e");
    }
  }

  void setRole(int type) {
    role.value = type;
    update();
  }

  void setBirthDate(String date) {
    birthDate.value = date;
    birthDateController.text = date; // نحدث الكونترولر للنص
    update();
  }

  Future<void> signupUser() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        await api.signup(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          phone: phoneController.text.trim(),
          password: passwordController.text.trim(),
          confirmPassword: confirmPasswordController.text.trim(), // ← هنا

          birthDate: birthDate.value,
          role: role.value,

          profileImage: profileImage.value != null
              ? File(profileImage.value!.path)
              : null,

          idImage: idImage.value != null ? File(idImage.value!.path) : null,
        );

        Get.snackbar('Success', 'Account created successfully!');
        Get.to(() => Home());
      } on ServerException catch (e) {
        Get.snackbar('Error', e.errModel.errorMessage);
      }
    }
  }
}
