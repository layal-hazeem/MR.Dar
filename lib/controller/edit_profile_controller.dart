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

  // متغيرات التحميل
  final isLoading = false.obs;
  final isUpdating = false.obs;

  // معلومات المستخدم الحالية
  String? currentFirstName;
  String? currentLastName;
  String? currentPhone;
  String? currentProfileImage;

  // Controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // التحقق من الصحة
  final formKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();

  // إدارة الصور
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final ImagePicker picker = ImagePicker();

  // رسائل الأخطاء
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserData();
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

  // اختيار صورة جديدة
  Future<void> selectProfileImage() async {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () async {
                Get.back();
                final image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  selectedImage.value = image;
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () async {
                Get.back();
                final image = await picker.pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  selectedImage.value = image;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // التحقق إذا كانت هناك تغييرات
  bool get hasChanges {
    return firstNameController.text != currentFirstName ||
        lastNameController.text != currentLastName ||
        phoneController.text != currentPhone ||
        selectedImage.value != null;
  }

  bool get hasPasswordChanges {
    return newPasswordController.text.isNotEmpty ||
        confirmPasswordController.text.isNotEmpty;
  }

  // تحديث المعلومات الأساسية
  Future<bool> updateProfile({required String password}) async {
    try {
      isUpdating.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      // التحقق من كلمة المرور
      final isValidPassword = await _verifyPassword(password);
      if (!isValidPassword) {
        errorMessage.value = 'Incorrect password';
        isUpdating.value = false;
        return false;
      }

      // إعداد البيانات
      final formData = FormData(); // ✅ هذا صحيح الآن بعد استيراد Dio

      // البيانات النصية
      formData.fields.addAll([
        MapEntry('first_name', firstNameController.text.trim()),
        MapEntry('last_name', lastNameController.text.trim()),
        MapEntry('phone', phoneController.text.trim()),
        MapEntry('current_password', password), // إرسال كلمة المرور الحالية
      ]);

      // صورة الملف الشخصي الجديدة
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
        }
      }

      // إرسال الطلب
      final response = await userService.updateProfile(formData);

      if (response['success'] == true || response['status'] == 'success') {
        successMessage.value = 'Profile updated successfully!';

        // تحديث البيانات المحلية
        await myAccountController
            .loadProfile(); // ✅ إزالة forceRefresh إذا لم تكن موجودة

        // إعادة تعيين
        _loadCurrentUserData();
        selectedImage.value = null;

        return true;
      } else {
        errorMessage.value = response['message'] ?? 'Update failed';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  // تغيير كلمة المرور
  Future<bool> changePassword() async {
    try {
      isUpdating.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      // التحقق من صحة النموذج
      if (!passwordFormKey.currentState!.validate()) {
        isUpdating.value = false;
        return false;
      }

      // التحقق من تطابق كلمات المرور الجديدة
      if (newPasswordController.text != confirmPasswordController.text) {
        errorMessage.value = 'New passwords do not match';
        isUpdating.value = false;
        return false;
      }

      // التحقق من كلمة المرور القديمة
      final isValidPassword = await _verifyPassword(
        currentPasswordController.text,
      );
      if (!isValidPassword) {
        errorMessage.value = 'Current password is incorrect';
        isUpdating.value = false;
        return false;
      }

      // إعداد بيانات تغيير كلمة المرور
      final response = await userService.changePassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      if (response['success'] == true || response['status'] == 'success') {
        successMessage.value = 'Password changed successfully!';

        // إعادة تعيين الحقول
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        return true;
      } else {
        errorMessage.value = response['message'] ?? 'Password change failed';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  // التحقق من كلمة المرور الحالية
  Future<bool> _verifyPassword(String password) async {
    // هنا يمكنك إضافة API call للتحقق من كلمة المرور
    // أو استخدام الـ token الموجود
    return password.isNotEmpty && password.length >= 8;
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
