import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/dio_consumer.dart';
import '../core/api/end_points.dart';

class ReviewService {
  final DioConsumer api = Get.find<DioConsumer>();

  /// check if user can rate this house
  Future<bool> checkIfCanRate(int houseId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    final response = await api.dio.get(
      '${EndPoint.review}/check-if-can-rate/$houseId',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        validateStatus: (_) => true,
      ),
    );

    return response.statusCode == 200 && response.data['data'] == true;
  }

  /// submit review
  Future<bool> submitReview({required int houseId, required int rating}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    final response = await api.dio.post(
      EndPoint.review,
      data: {"house_id": houseId, "rating": rating},
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        validateStatus: (_) => true,
      ),
    );

    return response.statusCode == 200;
  }
}
