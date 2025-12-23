import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../model/user_model.dart';
import '../service/userService.dart';
import '../controller/my_account_controller.dart';

class EditProfileController extends GetxController {
  final UserService userService;
  final MyAccountController myAccountController;
  final passwordTextTrigger = 0.obs;

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

  // ✅ NEW: Password visibility for dialog (separate from main form)
  final showDialogPassword = false.obs;

  void onPasswordTextChanged() {
    passwordTextTrigger.value++;
  }

  @override
  void onInit() {
    super.onInit();

    // انتظر MyAccountController يجهز البيانات
    if (myAccountController.user.value != null) {
      _loadCurrentUserData();
    } else {
      // إذا مو جاهزة، استمع للتغيير
      ever(myAccountController.user, (UserModel? user) {
        if (user != null) {
          _loadCurrentUserData();
        }
      });
    }

    _listenToChanges();
  }

  void _loadCurrentUserData() {
    print("🔄 Loading user data into edit form...");

    final user = myAccountController.user.value;
    if (user != null) {
      currentFirstName = user.firstName;
      currentLastName = user.lastName;
      currentPhone = user.phone;
      currentProfileImage = user.profileImage;

      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      phoneController.text = user.phone;

      print("✅ Loaded: ${user.firstName} ${user.lastName}, ${user.phone}");

      update();
    } else {
      print("❌ No user data available");
    }
  }

  void _listenToChanges() {
    firstNameController.addListener(_checkChanges);
    lastNameController.addListener(_checkChanges);
    phoneController.addListener(_checkChanges);

    currentPasswordController.addListener(() {
      _checkChanges();
      onPasswordTextChanged();
    });

    newPasswordController.addListener(() {
      _checkChanges();
      onPasswordTextChanged();
    });

    confirmPasswordController.addListener(() {
      _checkChanges();
      onPasswordTextChanged();
    });
  }

  void _checkChanges() {
    final hadChanges = hasProfileChanges.value;

    // ✅ UPDATED: Check both profile AND password changes
    hasProfileChanges.value =
        firstNameController.text.trim() != currentFirstName ||
        lastNameController.text.trim() != currentLastName ||
        phoneController.text.trim() != currentPhone ||
        selectedImage.value != null ||
        currentPasswordController
            .text
            .isNotEmpty || // ✅ NEW: Password changes count too
        newPasswordController
            .text
            .isNotEmpty || // ✅ NEW: Password changes count too
        confirmPasswordController
            .text
            .isNotEmpty; // ✅ NEW: Password changes count too

    // ✅ NEW: Show notification when changes are detected
    if (!hadChanges && hasProfileChanges.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Changes Detected',
          'You have unsaved changes',
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
          duration: Duration(seconds: 2),
          icon: Icon(Icons.edit, color: Colors.orange),
        );
      });
    }
  }

  // ✅ UPDATED: Separate logic for different types of changes

  // 1. تغييرات في المعلومات الأساسية فقط (الاسم، الرقم، الصورة)
  bool get hasBasicInfoChanges {
    return firstNameController.text.trim() != currentFirstName ||
        lastNameController.text.trim() != currentLastName ||
        phoneController.text.trim() != currentPhone ||
        selectedImage.value != null;
  }

  // 2. تغييرات في كلمة السر فقط (فقط - بدون معلومات أساسية)
  bool get hasPasswordOnlyChanges {
    final currentPass = currentPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    // ✅ إذا المستخدم حط بيانات في حقول الباسوورد
    return currentPass.isNotEmpty ||
        newPass.isNotEmpty ||
        confirmPass.isNotEmpty;
  }

  // 3. أي تغييرات (أي نوع)
  bool get hasChanges => hasBasicInfoChanges || hasPasswordOnlyChanges;

  // 4. التغييرات في الباسوورد (القديم والجديد)
  bool get hasPasswordChanges => hasPasswordOnlyChanges; // ✅ NEW: clearer name

  // 5. تحقق من صحة الرقم (10 أرقام فقط)
  bool get isPhoneValid {
    final phone = phoneController.text.trim();
    return phone.length == 10 && RegExp(r'^[0-9]{10}$').hasMatch(phone);
  }

  // 6. تحقق إذا التغييرات صحيحة وجاهزة للحفظ
  bool get hasValidChanges {
    if (!hasChanges) return false;

    // ✅ إذا في تغيير بالباسوورد فقط
    if (hasPasswordOnlyChanges && !hasBasicInfoChanges) {
      return isPasswordChangeValid();
    }

    // ✅ إذا في تغيير بالمعلومات الأساسية فقط
    if (hasBasicInfoChanges && !hasPasswordOnlyChanges) {
      return _isBasicInfoValid();
    }

    // ✅ إذا في تغيير بالاثنين معاً
    return isPasswordChangeValid() && _isBasicInfoValid();
  }

  // 7. تحقق من صحة المعلومات الأساسية
  bool _isBasicInfoValid() {
    // إذا غير الرقم، تحقق من صحته
    if (phoneController.text.trim() != currentPhone) {
      return isPhoneValid;
    }
    return true;
  }

  // 8. تحقق من صحة تغيير الباسوورد
  bool isPasswordChangeValid() {
    final currentPass = currentPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    // إذا ما حط شي، ما في تغيير
    if (currentPass.isEmpty && newPass.isEmpty && confirmPass.isEmpty) {
      return false;
    }

    // إذا حط في حقول الباسوورد، لازم يكونوا كاملين وصحيحين
    return currentPass.isNotEmpty &&
        newPass.isNotEmpty &&
        confirmPass.isNotEmpty &&
        newPass.length >= 8 &&
        newPass == confirmPass;
  }

  // 9. رسالة الخطأ حسب نوع التغيير
  String? get changesError {
    if (hasPasswordOnlyChanges && !isPasswordChangeValid()) {
      if (currentPasswordController.text.trim().isEmpty) {
        return 'Enter current password';
      }
      if (newPasswordController.text.trim().length < 8) {
        return 'New password must be at least 8 characters';
      }
      if (newPasswordController.text.trim() !=
          confirmPasswordController.text.trim()) {
        return 'Passwords do not match';
      }
      return 'Password requirements not met';
    }

    if (hasBasicInfoChanges &&
        phoneController.text.trim() != currentPhone &&
        !isPhoneValid) {
      return 'Phone must be 10 digits';
    }

    return null;
  }

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
      print("🔄 Starting updateProfile...");

      isUpdating.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      print("📤 Sending data:");
      print("  - first_name: ${firstNameController.text.trim()}");
      print("  - last_name: ${lastNameController.text.trim()}");
      print("  - phone: ${phoneController.text.trim()}");
      print("  - current_password: $password");
      print("  - has new image: ${selectedImage.value != null}");

      final formData = FormData();

      formData.fields.addAll([
        MapEntry('first_name', firstNameController.text.trim()),
        MapEntry('last_name', lastNameController.text.trim()),
        MapEntry('phone', phoneController.text.trim()),
        MapEntry('current_password', password),
      ]);

      if (selectedImage.value != null) {
        final file = File(selectedImage.value!.path);
        if (file.existsSync()) {
          formData.files.add(
            MapEntry(
              'profile_image',
              await MultipartFile.fromFile(
                file.path,
                filename:
                    'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
              ),
            ),
          );
          print("📎 Added profile image file");
        }
      }

      print("📤 Sending request to updateProfile API...");
      final response = await userService.updateProfile(formData);
      print("📨 Response received: $response");

      if (response['message']?.toString().toLowerCase().contains('success') ==
              true ||
          response['status']?.toString().toLowerCase() == 'success' ||
          response['data'] != null) {
        successMessage.value = 'Profile updated successfully!';
        print("✅ Profile update successful!");

        try {
          print("🔄 Refreshing MyAccountController data...");
          await myAccountController.loadProfile();
        } catch (e) {
          print("⚠️ Could not refresh myAccountController: $e");
        }

        _loadCurrentUserData();
        selectedImage.value = null;
        hasProfileChanges.value = false;

        return true;
      } else {
        final errorMsg =
            response['message'] ?? response['error'] ?? 'Update failed';
        errorMessage.value = errorMsg;
        print("❌ Update failed: $errorMsg");
        return false;
      }
    } catch (e) {
      print("❌ Exception in updateProfile: $e");
      errorMessage.value = 'Something went wrong: ${e.toString()}';
      return false;
    } finally {
      isUpdating.value = false;
      update();
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
