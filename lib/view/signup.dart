// Updated Signup screen with white background design similar to Login
// Paste this file in place of your current signup.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/signupcontroller.dart';
import '../service/auth_service.dart';

class Signup extends StatelessWidget {
  Signup({super.key});
  final SignupController controller = Get.put(
    SignupController(api: Get.find<AuthService>()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // <-- خلفية بيضاء
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF274668)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10.h),
                Text(
                  "Join us and find your perfect home",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF274668),
                  ),
                ),
                SizedBox(height: 20.h),

                // اختيار النوع
                GetBuilder<SignupController>(
                  builder: (ctrl) {
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => ctrl.setRole(2),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: ctrl.role.value == 2
                                    ? const Color(0xFF274668)
                                    : const Color(0xFFE8ECF4),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "Renter",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ctrl.role.value == 2
                                        ? Colors.white
                                        : const Color(0xFF274668),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => ctrl.setRole(3),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: ctrl.role.value == 3
                                    ? const Color(0xFF274668)
                                    : const Color(0xFFE8ECF4),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "Owner",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ctrl.role.value == 3
                                        ? Colors.white
                                        : const Color(0xFF274668),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: 15.h),

                // First & Last Name
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.firstNameController,
                        maxLength: 20,
                        style: const TextStyle(
                          color: Color(0xFF274668),
                          fontSize: 22,
                        ),
                        validator: (v) =>
                            v!.isEmpty ? "First name is required!" : null,
                        decoration: _inputDecoration("First name"),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: controller.lastNameController,
                        maxLength: 20,
                        style: const TextStyle(
                          color: Color(0xFF274668),
                          fontSize: 22,
                        ),
                        validator: (v) =>
                            v!.isEmpty ? "Last name is required!" : null,
                        decoration: _inputDecoration("Last name"),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15.h),

                // Date of Birth
                GetBuilder<SignupController>(
                  builder: (ctrl) {
                    return TextFormField(
                      readOnly: true,
                      controller: ctrl.birthDateController,
                      decoration: _inputDecoration(
                        "Date of Birth",
                        suffix: Icons.calendar_today,
                      ),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          ctrl.setBirthDate(
                            "${picked.day}/${picked.month}/${picked.year}",
                          );
                        }
                      },
                      validator: (v) =>
                          v!.isEmpty ? "Date of Birth is required" : null,
                    );
                  },
                ),

                SizedBox(height: 15.h),

                // Images
                GetBuilder<SignupController>(
                  builder: (ctrl) {
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => ctrl.selectProfileImage(),
                            child: AbsorbPointer(
                              child: TextFormField(
                                readOnly: true,
                                decoration: _inputDecoration(
                                  ctrl.profileImage.value == null
                                      ? "Profile Image"
                                      : "Image Selected ✔",
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => ctrl.pickIdImage(),
                            child: AbsorbPointer(
                              child: TextFormField(
                                readOnly: true,
                                decoration: _inputDecoration(
                                  ctrl.idImage.value == null
                                      ? "ID Image"
                                      : "Image Selected ✔",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: 15.h),

                // Phone
                TextFormField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  style: const TextStyle(color: Colors.black87, fontSize: 22),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Phone is required";
                    if (v.length != 10) return "Phone must be 10 digits";
                    return null;
                  },
                  decoration: _inputDecoration("Phone", suffix: Icons.phone),
                ),

                SizedBox(height: 15.h),

                // Password
                GetBuilder<SignupController>(
                  builder: (ctrl) {
                    return TextFormField(
                      controller: ctrl.passwordController,
                      obscureText: ctrl.isPasswordHidden,
                      maxLength: 15,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 22,
                      ),
                      validator: (v) {
                        if (v!.isEmpty) return "Password required";
                        if (v.length < 8) return "Must be at least 8 chars";
                        return null;
                      },
                      decoration: _inputDecoration(
                        "Password",
                        suffixWidget: IconButton(
                          icon: Icon(
                            ctrl.isPasswordHidden
                                ? Icons.lock
                                : Icons.lock_open,
                            color: Colors.black45,
                          ),
                          onPressed: ctrl.togglePassword,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 15.h),

                // Confirm Password
                GetBuilder<SignupController>(
                  builder: (ctrl) {
                    return TextFormField(
                      controller: ctrl.confirmPasswordController,
                      obscureText: ctrl.isConfirmHidden,
                      maxLength: 15,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 22,
                      ),
                      validator: (v) {
                        if (v!.isEmpty) return "Confirm is required";
                        if (v != ctrl.passwordController.text)
                          return "Not matching";
                        return null;
                      },
                      decoration: _inputDecoration(
                        "Confirm Password",
                        suffixWidget: IconButton(
                          icon: Icon(
                            ctrl.isConfirmHidden ? Icons.lock : Icons.lock_open,
                            color: Colors.black45,
                          ),
                          onPressed: ctrl.toggleConfirmPassword,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20.h),

                // Sign Up Button
                GetBuilder<SignupController>(
                  builder: (ctrl) {
                    return ElevatedButton(
                      onPressed: ctrl.isLoading
                          ? null
                          : () => controller.signupUser(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF274668),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: ctrl.isLoading
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                    );
                  },
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label, {
    IconData? suffix,
    Widget? suffixWidget,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black45,
        fontSize: 18,
      ),
      suffixIcon:
          suffixWidget ??
          (suffix != null ? Icon(suffix, color: Colors.black45) : null),
      fillColor: const Color(0xFFF5F5F5),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF274668), width: 2),
      ),
    );
  }
}
