// lib/view/edit_profile_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/edit_profile_controller.dart';
import '../controller/my_account_controller.dart';
import '../service/userService.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final EditProfileController controller = Get.put(
    EditProfileController(
      userService: Get.find<UserService>(),
      myAccountController: Get.find<MyAccountController>(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Color(0xFF274668),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // ===== رسائل النجاح/الخطأ =====
              if (controller.errorMessage.value.isNotEmpty)
                _buildMessageCard(
                  controller.errorMessage.value,
                  Colors.red.shade50,
                  Colors.red,
                ),
              if (controller.successMessage.value.isNotEmpty)
                _buildMessageCard(
                  controller.successMessage.value,
                  Colors.green.shade50,
                  Colors.green,
                ),

              SizedBox(height: 20),

              // ===== صورة الملف الشخصي =====
              _buildProfileImageSection(),

              SizedBox(height: 30),

              // ===== المعلومات الأساسية =====
              _buildBasicInfoSection(),

              SizedBox(height: 30),

              // ===== تغيير كلمة المرور =====
              _buildPasswordSection(),

              SizedBox(height: 40),
            ],
          ),
        );
      }),
      floatingActionButton: Obx(() {
        if (controller.hasChanges || controller.hasPasswordChanges) {
          return FloatingActionButton.extended(
            onPressed: () => _showSaveDialog(context),
            icon: Icon(Icons.save),
            label: Text('Save Changes'),
            backgroundColor: Color(0xFF274668),
          );
        }
        return SizedBox.shrink();
      }),
    );
  }

  Widget _buildMessageCard(String message, Color bgColor, Color textColor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(message, style: TextStyle(color: textColor, fontSize: 14)),
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      children: [
        Text(
          'Profile Picture',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF274668),
          ),
        ),
        SizedBox(height: 16),

        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Obx(() {
              final currentImage = controller.currentProfileImage;
              final selectedImage = controller.selectedImage.value;

              if (selectedImage != null) {
                return CircleAvatar(
                  radius: 60,
                  backgroundImage: FileImage(File(selectedImage.path)),
                );
              } else if (currentImage != null && currentImage.isNotEmpty) {
                return CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(currentImage),
                  backgroundColor: Colors.transparent,
                );
              } else {
                return CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                );
              }
            }),

            Container(
              decoration: BoxDecoration(
                color: Color(0xFF274668),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                onPressed: controller.selectProfileImage,
              ),
            ),
          ],
        ),

        SizedBox(height: 8),
        Text(
          'Tap camera icon to change photo',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF274668),
                ),
              ),
              SizedBox(height: 20),

              // First Name
              TextFormField(
                controller: controller.firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Last Name
              TextFormField(
                controller: controller.lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last name is required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Phone
              TextFormField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone is required';
                  }
                  if (value.length != 10) {
                    return 'Phone must be 10 digits';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: controller.passwordFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF274668),
                ),
              ),
              SizedBox(height: 20),

              // Current Password
              TextFormField(
                controller: controller.currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (controller.hasPasswordChanges &&
                      (value == null || value.isEmpty)) {
                    return 'Current password is required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // New Password
              TextFormField(
                controller: controller.newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (controller.currentPasswordController.text.isNotEmpty &&
                      (value == null || value.length < 8)) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                controller: controller.confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  prefixIcon: Icon(Icons.lock_reset),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (controller.newPasswordController.text.isNotEmpty &&
                      value != controller.newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Note
              Text(
                'Note: Fill current password only if you want to change it',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Changes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.hasChanges)
              Text('You have changed your profile information.'),
            if (controller.hasPasswordChanges)
              Text('You have changed your password.'),
            SizedBox(height: 10),
            Text('Please enter your current password to confirm:'),
            SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  controller.currentPasswordController.text = value,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          Obx(() {
            return ElevatedButton(
              onPressed: controller.isUpdating.value
                  ? null
                  : () async {
                      if (controller.hasPasswordChanges) {
                        // تغيير كلمة المرور
                        final success = await controller.changePassword();
                        if (success) {
                          Get.back();
                          Get.snackbar(
                            'Success',
                            'Password changed successfully!',
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        }
                      } else if (controller.hasChanges) {
                        // تحديث الملف الشخصي
                        final success = await controller.updateProfile(
                          password: controller.currentPasswordController.text,
                        );
                        if (success) {
                          Get.back();
                          Get.snackbar(
                            'Success',
                            'Profile updated successfully!',
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        }
                      }
                    },
              child: controller.isUpdating.value
                  ? CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF274668),
              ),
            );
          }),
        ],
      ),
    );
  }
}
