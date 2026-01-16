import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/enums/reservation_status.dart'
    show ReservationStatus, ReservationStatusExtension;
import '../model/reservation_model.dart';
import '../service/booking_service.dart';
import '../view/booking_date_page.dart';

class MyRentsController extends GetxController {
  final BookingService bookingService;

  MyRentsController({required this.bookingService});
  //all reservations
  final RxList<ReservationModel> allReservations = <ReservationModel>[].obs;

  final Rx<ReservationStatus> currentStatus = ReservationStatus.pending.obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isProcessing = false.obs;
  final highlightedReservationId = RxnInt();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    debugPrint(' MyRentsController INIT $hashCode');
    fetchMyReservations();
  }

  Future<void> reload() async {
    await fetchMyReservations();
  }

  void handleNotification({
    required String status,
    required int reservationId,
  }) {
    currentStatus.value = ReservationStatusExtension.fromString(status);

    highlightedReservationId.value = reservationId;
  }

  void scrollToReservation(int reservationId) {
    final index = filteredReservations.indexWhere((r) => r.id == reservationId);

    if (index == -1) return;

    scrollController.animateTo(
      index * 170.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> fetchMyReservations() async {
    debugPrint("fetchMyReservations START");

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final reservations = await bookingService.getMyReservations();

      debugPrint("API returned: ${reservations.length}");

      allReservations.assignAll(reservations);

      debugPrint("allReservations now: ${allReservations.length}");
    } catch (e) {
      debugPrint("ERROR: $e");
      errorMessage.value = 'load reservation failed'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  void changeStatus(ReservationStatus status) {
    currentStatus.value = status;
  }

  ReservationStatus _mapStatus(String status) {
    return ReservationStatusExtension.fromString(status);
  }

  List<ReservationModel> get filteredReservations {
    final now = DateTime.now();

    return allReservations.where((reservation) {
      final status = _mapStatus(reservation.status);

      final end = DateTime.parse(reservation.endDate);

      if (currentStatus.value == ReservationStatus.accepted) {
        return status == ReservationStatus.accepted;
      }

      if (currentStatus.value == ReservationStatus.previous) {
        return status == ReservationStatus.previous ||
            (status == ReservationStatus.accepted && end.isBefore(now));
      }

      return status == currentStatus.value;
    }).toList();
  }

  void setReservations(List<ReservationModel> reservations) {
    allReservations.assignAll(reservations);
  }

  void clearReservations() {
    allReservations.clear();
  }

  Future<void> cancelReservation(int reservationId) async {
    try {
      isProcessing.value = true;

      final success = await bookingService.cancelReservation(reservationId);

      if (success) {
        final index = allReservations.indexWhere((r) => r.id == reservationId);
        if (index != -1) {
          allReservations[index] = allReservations[index].copyWith(
            status: 'canceled',
          );
          allReservations.refresh();
        }

        Get.snackbar(
          "Success".tr,
          "Reservation cancelled successfully".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception("Failed to cancel reservation".tr);
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "Failed to cancel reservation: ${e.toString()}".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  void editReservation(ReservationModel reservation) {
    Get.defaultDialog(
      title: "Edit Reservation".tr,
      middleText:
          "Editing will cancel the current request and create a new one. Continue?"
              .tr,
      textConfirm: "Yes, Edit".tr,
      textCancel: "CANCEL".tr,
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF274668),
      onConfirm: () async {
        Get.back();

        await cancelReservation(reservation.id);

        Get.to(
          () => BookingDatePage(
            houseId: reservation.apartment.id,
            rentValue: reservation.apartment.rentValue,
            initialStartDate: reservation.startDate,
            initialDuration: reservation.duration,
          ),
          arguments: reservation.apartment,
        );
      },
    );
  }
}
