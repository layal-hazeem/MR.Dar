import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart'; // ✅ أضف هذا الاستيراد
import '../service/userService.dart';
import '../controller/my_account_controller.dart';

class EditProfileController extends GetxController {
  final UserService userService;
  final MyAccountController myAccountController;

  EditProfileController({
    required this.userService,
    required this.myAccountController,
  });

  // Loading
  final isLoading = false.obs;
  final isUpdating = false.obs;

  // Current data
  String? currentFirstName;
  String? currentLastName;
  String? currentPhone;
  String? currentProfileImage;

  // Text Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Dialog password
  final confirmDialogPasswordController = TextEditingController();

  // Forms
  final formKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();

  // Image
  final selectedImage = Rx<XFile?>(null);
  final picker = ImagePicker();

  // Messages
  final errorMessage = ''.obs;
  final successMessage = ''.obs;

  // Changes tracking
  final hasProfileChanges = false.obs;

  // Password visibility
  final showCurrentPassword = false.obs;
  final showNewPassword = false.obs;
  final showConfirmPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserData();
    _listenToChanges();
  }

  void _loadCurrentUserData() {
    final user = myAccountController.user.value;
    if (user != null) {
      currentFirstName = user.firstName;
      currentLastName = user.lastName;
      currentPhone = user.phone;
      currentProfileImage = user.profileImage;

      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      phoneController.text = user.phone;
    }
  }

  void _listenToChanges() {
    firstNameController.addListener(_checkChanges);
    lastNameController.addListener(_checkChanges);
    phoneController.addListener(_checkChanges);
  }

  void _checkChanges() {
    hasProfileChanges.value =
        firstNameController.text.trim() != currentFirstName ||
        lastNameController.text.trim() != currentLastName ||
        phoneController.text.trim() != currentPhone ||
        selectedImage.value != null;
  }

  bool get hasChanges => hasProfileChanges.value;

  bool get hasPasswordChanges =>
      newPasswordController.text.isNotEmpty ||
      confirmPasswordController.text.isNotEmpty;

  // Image picker
  Future<void> selectProfileImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = image;
      _checkChanges();
    }
  }

  // Update profile
  Future<bool> updateProfile({required String password}) async {
    try {
      isUpdating.value = true;

      final formData = FormData();
      formData.fields.addAll([
        MapEntry('first_name', firstNameController.text.trim()),
        MapEntry('last_name', lastNameController.text.trim()),
        MapEntry('phone', phoneController.text.trim()),
        MapEntry('current_password', password),
      ]);

      if (selectedImage.value != null) {
        final file = File(selectedImage.value!.path);
        formData.files.add(
          MapEntry('profile_image', await MultipartFile.fromFile(file.path)),
        );
      }

      final response = await userService.updateProfile(formData);

      if (response['success'] == true || response['status'] == 'success') {
        await myAccountController.loadProfile();
        _loadCurrentUserData();
        selectedImage.value = null;
        hasProfileChanges.value = false;
        return true;
      }
      errorMessage.value = response['message'] ?? 'Update failed';
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  // Change password
  Future<bool> changePassword() async {
    if (!passwordFormKey.currentState!.validate()) return false;

    final response = await userService.changePassword(
      currentPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    if (response['success'] == true || response['status'] == 'success') {
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      return true;
    }
    errorMessage.value = response['message'] ?? 'Password change failed';
    return false;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
