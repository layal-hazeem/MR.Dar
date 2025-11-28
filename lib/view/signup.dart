import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controller/signupcontroller.dart';
import 'home.dart';

class Signup extends StatelessWidget {
  Signup({super.key});
  final signupController controller = Get.put(signupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8E8E8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),

      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: const Color(0xFFE8E8E8),

            child: Form(
              key: controller.formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 5.h),

                  Center(
                    child: Container(
                      height: 250,
                      margin: EdgeInsets.only(top: 5),

                      child: Image.asset(
                        "images/photo_2025-11-27_11-23-04.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: 25.h),

                  /// First & Last Name
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.firstNameController,
                          maxLength: 20,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 22,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "First name is required!";
                            }
                            return null;
                          },
                          decoration: _inputDecoration("First name"),
                        ),
                      ),

                      SizedBox(width: 10),

                      Expanded(
                        child: TextFormField(
                          controller: controller.lastNameController,
                          maxLength: 20,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 22,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Last name is required!";
                            }
                            return null;
                          },
                          decoration: _inputDecoration("Last name"),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15.h),

                  GetBuilder<signupController>(
                    builder: (ctrl) {
                      return TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: ctrl.birthDate.value,
                        ),
                        decoration: _inputDecoration(
                          "Date of Birth",
                          suffix: Icons.calendar_today,
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            ctrl.setBirthDate(formattedDate);
                          }
                        },
                        validator: (value) {
                          if (ctrl.birthDate.value.isEmpty) {
                            return "Date of Birth is required!";
                          }
                          return null;
                        },
                      );
                    },
                  ),

                  SizedBox(height: 15.h),

                  /// Phone
                  TextFormField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    style: const TextStyle(color: Colors.black87, fontSize: 22),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone number is required!";
                      }
                      if (value.length != 10) {
                        return "Phone number must be 10 numbers!";
                      }
                      return null;
                    },
                    decoration: _inputDecoration("Phone", suffix: Icons.phone),
                  ),

                  SizedBox(height: 15.h),

                  /// Password
                  GetBuilder<signupController>(
                    builder: (ctrl) {
                      return TextFormField(
                        controller: ctrl.passwordController,
                        obscureText: true,
                        maxLength: 15,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required!";
                          }
                          if (value.length < 7) {
                            return "Password must be at least 7 characters!";
                          }
                          return null;
                        },
                        decoration: _inputDecoration("Password"),
                      );
                    },
                  ),

                  SizedBox(height: 25.h),

                  /// Button
                  SizedBox(
                    height: 55.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF08D9CE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                      ),
                      onPressed: () {
                        if (controller.validateSignup()) {
                          Get.to(Home());
                        }
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {IconData? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black45,
        fontSize: 18,
      ),
      suffixIcon: suffix != null
          ? Icon(suffix, color: Colors.black45, size: 28)
          : null,
      fillColor: const Color(0xFFCFFDFA),
      filled: true,
      border: OutlineInputBorder(),
    );
  }
}
