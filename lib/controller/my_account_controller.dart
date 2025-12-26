import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';
import '../service/UserLocalService.dart';
import '../service/userService.dart';
import 'authcontroller.dart';

class MyAccountController extends GetxController {
  final UserService service;
  final UserLocalService localService = UserLocalService();
  final isDeleting = false.obs;
  final deletePasswordController = TextEditingController();
  MyAccountController({required this.service});

  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final isDataFromLocal = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProfile();
    });
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      update();

      final localData = await localService.getUserData();
      if (localData['token'] != null && localData['id'] != null) {
        user.value = _createUserFromLocalData(localData);
        isDataFromLocal.value = true;
      }

      try {
        final apiUser = await service.getProfile();
        user.value = apiUser;
        isDataFromLocal.value = false;

        // تحديث البيانات المحلية
        await _updateLocalData(apiUser);
      } catch (e) {
        print("Failed to fetch from API: $e");
        if (user.value == null) {
          throw Exception("No data available");
        }
      }
    } catch (e) {
      print("Error loading profile: $e");
      if (user.value == null) {
        user.value = null;
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  String _fixImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';

    if (url.startsWith('storage/')) {
      return 'http://10.0.2.2:8000/storage/${url.substring(8)}';
    }

    if (url.startsWith('/storage/')) {
      return 'http://10.0.2.2:8000$url';
    }

    if (url.contains('localhost:8000')) {
      return url.replaceAll('localhost:8000', '10.0.2.2:8000');
    }

    if (url.contains('127.0.0.1:8000')) {
      return url.replaceAll('127.0.0.1:8000', '10.0.2.2:8000');
    }

    return url;
  }

  UserModel _createUserFromLocalData(Map<String, dynamic> data) {
    return UserModel(
      id: int.tryParse(data['id'] ?? '0') ?? 0,
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? 'renter',
      dateOfBirth: data['date_of_birth'] ?? '',
      profileImage: _fixImageUrl(data['profile_image']),
      idImage: _fixImageUrl(data['id_image']),
    );
  }

  Future<void> _updateLocalData(UserModel user) async {
    await localService.saveUserData({
      'id': user.id.toString(),
      'first_name': user.firstName,
      'last_name': user.lastName,
      'phone': user.phone,
      'role': user.role,
      'date_of_birth': user.dateOfBirth,
      'profile_image': user.profileImage,
      'id_image': user.idImage,
    });
  }

  Future<void> updateUserAfterSignup(Map<String, dynamic> userData) async {
    await localService.saveUserData(userData);
    user.value = _createUserFromLocalData(userData);
    isDataFromLocal.value = true;
    update();
  }

  Future<void> verifyAndDeleteAccount(String password) async {
    if (password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your password",
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      isDeleting.value = true;

      final response = await service.deleteAccount(password);

      if (response['status'] == 'success' || response['message'] != null) {
        if (Get.isDialogOpen!) Get.back();
        final authController = Get.find<AuthController>();
        await authController.logout();

        Get.snackbar(
          "Account Deleted",
          "Your account has been permanently removed",
          backgroundColor: Colors.black,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Delete Error: $e");
      Get.snackbar(
        "Failed",
        "Could not delete account. Please check your password.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  void showDeleteAccountFlow(BuildContext context) {
    Get.defaultDialog(
      title: "Delete Account?",
      middleText: "Are you sure? This action cannot be undone.",
      textConfirm: "Next",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        _showPasswordVerifyDialog(context);
      },
      onCancel: () {
        Get.closeAllSnackbars();
      },
    );
  }

  void _showPasswordVerifyDialog(BuildContext context) {
    deletePasswordController.clear();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Verify Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Please enter your password to confirm deletion:"),
            const SizedBox(height: 15),
            TextField(
              controller: deletePasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: isDeleting.value
                  ? null
                  : () => verifyAndDeleteAccount(deletePasswordController.text),
              child: isDeleting.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Confirm Delete",
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    deletePasswordController.dispose();
    super.onClose();
  }
}
