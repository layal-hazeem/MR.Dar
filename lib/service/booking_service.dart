import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/dio_consumer.dart';
import '../core/api/end_points.dart';
import '../model/booking_model.dart';
import '../model/owner_reservation_model.dart';
import '../model/reservation_model.dart';

class BookingService {
  final DioConsumer api;

  BookingService({required this.api});

  Future<List<Booking>> getHouseReservations(int houseId) async {
    final response = await api.dio.get(
      '${EndPoint.reservations}/house/$houseId',
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode == 200) {
      final List list = response.data['data'];

      return list.map((e) => Booking.fromJson(e, houseId: houseId)).toList();
    }

    return [];
  }

  Future<List<OwnerReservation>> getOwnerReservations() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    final response = await api.dio.get(
      '${EndPoint.reservations}/my-rents',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        validateStatus: (_) => true,
      ),
    );

    if (response.statusCode == 200) {
      final List list = response.data['data'];
      return list.map((e) => OwnerReservation.fromJson(e)).toList();
    }

    return [];
  }

  Future<bool> approveReservation(int houseId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    final response = await api.dio.put(
      '${EndPoint.reservations}/accept/$houseId',
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

  Future<bool> createReservation({
    required int houseId,
    required String startDate,
    required int duration,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    final response = await api.dio.post(
      EndPoint.reservations,
      data: {
        "house_id": houseId,
        "start_date": startDate,
        "duration": duration,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        validateStatus: (_) => true,
      ),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<List<ReservationModel>> getMyReservations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      final response = await api.dio.get(
        '${EndPoint.reservations}/my-rents',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          validateStatus: (_) => true,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data.containsKey('data')) {
          final List list = data['data'];
          return list.map((e) => ReservationModel.fromJson(e)).toList();
        }
      }

      return [];
    } on DioException catch (e) {
      debugPrint("getMyReservations error: ${e.message}");
      return [];
    }
  }

  Future<bool> cancelReservation(int reservationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    final response = await api.dio.put(
      '${EndPoint.reservations}/cancel/$reservationId',
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

  Future<bool> rejectReservation(int reservationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    final response = await api.dio.put(
      '${EndPoint.reservations}/reject/$reservationId',
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

  Future<bool> acceptReservation(int reservationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    final response = await api.dio.put(
      '${EndPoint.reservations}/accept/$reservationId',
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

  Future<bool> updateReservation({
    required int reservationId,
    required String startDate,
    required int duration,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    final response = await api.dio.put(
      '${EndPoint.reservations}/$reservationId',
      data: {"start_date": startDate, "duration": duration},
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
