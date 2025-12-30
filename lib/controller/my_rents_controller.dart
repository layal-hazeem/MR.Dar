import 'package:get/get.dart';

import '../core/enums/reservation_status.dart' show ReservationStatus, ReservationStatusExtension;
import '../model/reservation_model.dart';
import '../service/booking_service.dart';

class MyRentsController extends GetxController {
  final BookingService bookingService;

  MyRentsController({required this.bookingService});

  // جميع الحجوزات
  final RxList<ReservationModel> allReservations = <ReservationModel>[].obs;
  // الحالة الحالية
  final Rx<ReservationStatus> currentStatus = ReservationStatus.pending.obs;
  //حالات الواجهة
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print('و🔥 MyRentsController INIT ${hashCode}');
    fetchMyReservations();
  }

  /// جلب الحجوزات من السيرفر
  Future<void> fetchMyReservations() async {

    print("🟡 fetchMyReservations START");

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final reservations = await bookingService.getMyReservations();

      print("🟢 API returned: ${reservations.length}");

      allReservations.assignAll(reservations);

      print("🟢 allReservations now: ${allReservations.length}");
    } catch (e) {
      print("🔴 ERROR: $e");
      errorMessage.value = 'load reservation failed';
    } finally {
      isLoading.value = false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final reservations = await bookingService.getMyReservations();
      print('🧾 reservations count = ${reservations.length}');
      print("🟢 fetched reservations: ${reservations.length}");
      allReservations.assignAll(reservations);
    } catch (e) {
      errorMessage.value = 'load reservation failed';
    } finally {
      isLoading.value = false;
    }
  }

  // تغيير الحالة (عند الضغط على Tab / Button)
  void changeStatus(ReservationStatus status) {
    currentStatus.value = status;
  }

  /// تحويل status النصي إلى enum
  ReservationStatus _mapStatus(String status) {
    return ReservationStatusExtension.fromString(status);
  }

  /// الحجوزات المفلترة
  List<ReservationModel> get filteredReservations {
    final now = DateTime.now();

    return allReservations.where((reservation) {
      final status = _mapStatus(reservation.status);

      final start = DateTime.parse(reservation.startDate);
      final end = DateTime.parse(reservation.endDate);

      // 🟢 حجز حالي (accepted + ضمن المدة)
      if (currentStatus.value == ReservationStatus.accepted) {
        return status == ReservationStatus.accepted &&
            start.isBefore(now) &&
            end.isAfter(now);
      }

      // 🔵 حجز سابق (انتهى)
      if (currentStatus.value == ReservationStatus.previous) {
        return end.isBefore(now);
      }

      // باقي الحالات
      return status == currentStatus.value;
    }).toList();
  }

  /// تحميل الحجوزات (API)
  void setReservations(List<ReservationModel> reservations) {
    allReservations.assignAll(reservations);
  }

  /// تفريغ البيانات (اختياري)
  void clearReservations() {
    allReservations.clear();
  }
}