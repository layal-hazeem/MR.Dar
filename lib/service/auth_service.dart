 import 'dart:io';

import 'package:dio/dio.dart';
import '../core/api/api_interceptors.dart';
import '../core/api/dio_consumer.dart';
import '../core/errors/exceptions.dart';

class AuthService {
// 1️⃣ إعداد Dio + interceptor + apiConsumer
final Dio dio = Dio();
late final DioConsumer apiConsumer;

AuthService() {
dio.interceptors.add(ApiInterceptor());
apiConsumer = DioConsumer(dio: dio);
}

// 2️⃣ دالة login
Future<void> login({required String phone, required String password}) async {
try {
final response = await apiConsumer.post(
'/login', // غيريه للـ endpoint الصحيح في السيرفر
data: {
'phone': phone,
'password': password,
},
);

print('Login success: $response');

// لاحقاً ممكن تخزني token أو بيانات المستخدم
} on SereverException catch (e) {
print('Login failed: ${e.errModel.errorMessage}');
throw e; // ترمي الخطأ للكونترولر ليعرض للمستخدم
}

}
  Future<void> signup({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String birthDate,
    required String userType,
    File? profileImage,
    File? idImage,
  }) async {
    try {
      FormData formData = FormData();

      // إضافة البيانات النصية
      formData.fields
        ..add(MapEntry('firstName', firstName))
        ..add(MapEntry('lastName', lastName))
        ..add(MapEntry('phone', phone))
        ..add(MapEntry('password', password))
        ..add(MapEntry('birthDate', birthDate))
        ..add(MapEntry('userType', userType));

      // إضافة الصور إذا موجودة
      if (profileImage != null) {
        formData.files.add(
          MapEntry(
            'profileImage',
            await MultipartFile.fromFile(profileImage.path, filename: profileImage.path.split('/').last),
          ),
        );
      }
      if (idImage != null) {
        formData.files.add(
          MapEntry(
            'idImage',
            await MultipartFile.fromFile(idImage.path, filename: idImage.path.split('/').last),
          ),
        );
      }

      // إرسال الطلب للباك
      final response = await apiConsumer.post(
        '/signup', // غيريه للـ endpoint الصحيح
        data: formData,
      );

      print('Signup success: $response');

    } on SereverException catch (e) {
      print('Signup failed: ${e.errModel.errorMessage}');
      throw e;
    }
  }
}
