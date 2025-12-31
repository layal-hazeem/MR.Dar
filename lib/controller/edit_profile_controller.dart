import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../service/userService.dart';
import '../controller/my_account_controller.dart';

class EditProfileController extends GetxController {
  final UserService userService;
  final MyAccountController myAccountController;

  EditProfileController({
    required this.userService,
    required this.myAccountController,
  });

  // States
  final isUpdating = false.obs;
  final hasAnyChanges = false.obs;
  final errorMessage = ''.obs;
  final dialogPasswordError = RxnString();

  // Text Controllers
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController dobController;
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final confirmDialogPasswordController = TextEditingController();

  // UI States
  final formKey = GlobalKey<FormState>();
  final selectedImage = Rx<XFile?>(null);
  final picker = ImagePicker();

  final showNewPassword = false.obs;
  final showConfirmPassword = false.obs;
  final showDialogPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initControllers();
  }

  void _initControllers() {
    final user = myAccountController.user.value;
    firstNameController = TextEditingController(text: user?.firstName ?? "");
    lastNameController = TextEditingController(text: user?.lastName ?? "");
    phoneController = TextEditingController(text: user?.phone ?? "");
    dobController = TextEditingController(text: user?.dateOfBirth ?? "");

    void listener() => checkChanges();
    firstNameController.addListener(listener);
    lastNameController.addListener(listener);
    phoneController.addListener(listener);
    dobController.addListener(listener);
    newPasswordController.addListener(listener);
    confirmPasswordController.addListener(listener);
  }

  void setBirthDate(String date) {
    dobController.text = date;
    checkChanges();
    update();
  }

  void checkChanges() {
    final user = myAccountController.user.value;
    if (user == null) return;

    bool changed =
        firstNameController.text.trim() != user.firstName ||
        lastNameController.text.trim() != user.lastName ||
        phoneController.text.trim() != user.phone ||
        dobController.text.trim() != user.dateOfBirth ||
        selectedImage.value != null ||
        newPasswordController.text.isNotEmpty;

    hasAnyChanges.value = changed;
  }

  Future<void> selectProfileImage() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      selectedImage.value = image;
      checkChanges();
    }
  }

  Future<bool> updateProfile({required String currentPassword}) async {
    try {
      isUpdating.value = true;
      errorMessage.value = '';
      dialogPasswordError.value = null; // 🔽 نمسح أي أخطاء سابقة

      final formData = FormData();

      // البيانات النصية
      formData.fields.addAll([
        MapEntry('first_name', firstNameController.text.trim()),
        MapEntry('last_name', lastNameController.text.trim()),
        MapEntry('phone', phoneController.text.trim()),
        MapEntry('date_of_birth', dobController.text.trim()),
        MapEntry('current_password', currentPassword),
      ]);

      // تغيير كلمة المرور (إن وُجد)
      if (newPasswordController.text.isNotEmpty) {
        formData.fields.addAll([
          MapEntry('new_password', newPasswordController.text.trim()),
          MapEntry(
            'new_password_confirmation',
            confirmPasswordController.text.trim(),
          ),
        ]);
      }

      // رفع صورة البروفايل (إن وُجدت)
      if (selectedImage.value != null) {
        formData.files.add(
          MapEntry(
            'profile_image',
            await MultipartFile.fromFile(
              selectedImage.value!.path,
              filename: selectedImage.value!.name,
            ),
          ),
        );
      }

      // طلب التحديث
      final response = await userService.updateProfile(formData);

      print('📡 API Response: ${response.toString()}'); // 🔽 أضف هذا للتصحيح

      if (response['status'] == 'success') {
        // 🔽 نمسح كل الرسائل عند النجاح
        errorMessage.value = '';
        dialogPasswordError.value = null;

        // تحديث البيانات محلياً
        final oldUser = myAccountController.user.value;
        if (oldUser != null) {
          myAccountController.user.value = oldUser.copyWith(
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            phone: phoneController.text.trim(),
            dateOfBirth: dobController.text.trim(),
            profileImage: selectedImage.value != null
                ? selectedImage.value!.path
                : oldUser.profileImage,
          );
        }

        myAccountController.update();
        _clearSensitiveData();
        return true; // 🔽 نجاح
      } else {
        // 🔽 فشل: نعرض رسالة الخطأ
        final errorMsg = response['message'] ?? 'Incorrect current password';
        errorMessage.value = errorMsg;
        dialogPasswordError.value = errorMsg; // 🔽 هام: نضيف قيمة للخطأ
        return false;
      }
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data['message'] ?? 'Validation Error: Check your data';
      errorMessage.value = errorMsg;
      dialogPasswordError.value = errorMsg; // 🔽 هام: نضيف قيمة للخطأ
      return false;
    } catch (e) {
      errorMessage.value = 'Connection failed. Please try again.';
      dialogPasswordError.value = errorMessage.value; // 🔽 هام: نضيف قيمة للخطأ
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  void _clearSensitiveData() {
    selectedImage.value = null;
    newPasswordController.clear();
    confirmPasswordController.clear();
    confirmDialogPasswordController.clear();
    hasAnyChanges.value = false;
    dialogPasswordError.value = null; // 🔽 تأكد من مسح الخطأ
    errorMessage.value = ''; // 🔽 تأكد من مسح الرسالة
    showDialogPassword.value = false; // 🔽 إعادة تعيين حالة إظهار كلمة السر
  }

  void clearDialogFields() {
    confirmDialogPasswordController.clear();
    dialogPasswordError.value = null;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    dobController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    confirmDialogPasswordController.dispose();
    super.onClose();
  }
}
