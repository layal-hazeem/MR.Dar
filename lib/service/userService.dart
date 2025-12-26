import 'package:dio/dio.dart';
import '../core/api/dio_consumer.dart';
import '../core/api/end_points.dart';
import '../model/user_model.dart';

class UserService {
  final DioConsumer api;
  UserService(this.api);

  Future<UserModel> getProfile() async {
    final response = await api.get(EndPoint.getAccount);
    return UserModel.fromJson(response["data"]);
  }

  Future<void> logout() async {
    await api.post(EndPoint.logout);
  }

  // في ملف user_service.dart

  Future<Map<String, dynamic>> deleteAccount(String password) async {
    final response = await api.dio.delete(
      EndPoint.deleteAccount,
      data: {
        'current_password': password, // حسب الاسم المتوقع في DeleteUserRequest
      },
      options: Options(headers: {'Accept': 'application/json'}),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> updateProfile(FormData formData) async {
    final response = await api.dio.post(
      EndPoint.updateAccount,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        headers: {'Accept': 'application/json'},
      ),
    );

    return response.data;
  }

  // ✅ دالة جديدة لتغيير كلمة المرور
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await api.dio.post(
      '${EndPoint.updateAccount}', // قد تحتاج لتعديل الـ endpoint
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      },
      options: Options(headers: {'Accept': 'application/json'}),
    );

    return response.data;
  }
}
