import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/apartment_model.dart';
import '../model/booking_model.dart';
import '../service/booking_service.dart';
import 'my_account_controller.dart';

class BookingController extends GetxController {
  final BookingService service;
  final int houseId;
  final double rentValue;
  late Apartment apartment;
  double get totalPrice => duration.value * rentValue;
  final accountController = Get.find<MyAccountController>();

  BookingController({
    required this.service,
    required this.houseId,
    required this.rentValue,
  });

  var selectedStartDate = Rxn<DateTime>();
  var duration = 1.obs;
  var isLoading = false.obs;

  var reservations = <Booking>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReservations();
  }

  Future<void> loadReservations() async {
    reservations.value = await service.getHouseReservations(houseId);
    reservations.refresh();
  }

  List<DateTime> get bookedDays {
    List<DateTime> days = [];

    for (var r in reservations) {
      if (r.status != 'accepted') continue;

      DateTime start = DateTime.parse(r.startDate);
      DateTime end = DateTime.parse(r.endDate);

      for (
        DateTime d = start;
        d.isBefore(end);
        d = d.add(const Duration(days: 1))
      ) {
        days.add(d);
      }
    }
    return days;
  }

  bool isDayBooked(DateTime day) {
    final checkDay = DateTime(day.year, day.month, day.day);

    for (var r in reservations) {
      if (r.status != 'accepted') continue;

      final start = DateTime.parse(r.startDate);
      final end = DateTime.parse(r.endDate);

      final startDay = DateTime(start.year, start.month, start.day);
      final endDay = DateTime(end.year, end.month, end.day);

      if (!checkDay.isBefore(startDay) && !checkDay.isAfter(endDay)) {
        return true;
      }
    }
    return false;
  }

  DateTime? get endDate {
    if (selectedStartDate.value == null) return null;

    final start = selectedStartDate.value!;

    DateTime tempEnd = DateTime(
      start.year,
      start.month + duration.value,
      start.day,
    );

    if (tempEnd.day != start.day) {
      tempEnd = DateTime(tempEnd.year, tempEnd.month, 0);
    }

    return tempEnd;
  }

  bool isStartDay(DateTime day) {
    if (selectedStartDate.value == null) return false;
    return isSameDay(day, selectedStartDate.value);
  }

  bool isEndDay(DateTime day) {
    if (endDate == null) return false;
    return isSameDay(day, endDate);
  }

  bool isInSelectedRange(DateTime day) {
    if (selectedStartDate.value == null || endDate == null) return false;

    final d = DateTime(day.year, day.month, day.day);
    final start = DateTime(
      selectedStartDate.value!.year,
      selectedStartDate.value!.month,
      selectedStartDate.value!.day,
    );
    final end = DateTime(endDate!.year, endDate!.month, endDate!.day);

    return d.isAfter(start) && d.isBefore(end);
  }

  int getDayStatus(DateTime day) {
    bool hasPending = false;

    for (var r in reservations) {
      DateTime start = DateTime.parse(r.startDate);
      DateTime end = DateTime.parse(r.endDate);

      if (!day.isBefore(start) && !day.isAfter(end)) {
        if (r.status == 'accepted') return 2;
        if (r.status == 'pending') {
          hasPending = true;
        }
      }
    }

    return hasPending ? 1 : 0;
  }

  bool isRangeAvailable() {
    if (selectedStartDate.value == null || endDate == null) return false;

    DateTime current = selectedStartDate.value!;

    while (current.isBefore(endDate!)) {
      if (isDayBooked(current)) return false;
      current = current.add(const Duration(days: 1));
    }
    return true;
  }

  Future<void> confirmBooking() async {
    if (selectedStartDate.value == null) return;

    if (!accountController.isAccountActive) {
      _showInactiveAccountDialog();
      return;
    }
    isLoading.value = true;
    final success = await service.createReservation(
      houseId: houseId,
      startDate: DateFormat('yyyy-MM-dd').format(selectedStartDate.value!),
      duration: duration.value,
    );
    isLoading.value = false;

    if (success) {
      Get.snackbar(
        "Success".tr,
        "Your reservation request has been sent".tr,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
      );
      _showResultDialog(
        title: "Booking Sent".tr,
        message:
            "Your request is pending. The owner can now see it and choose to accept it."
                .tr,
        type: 1, // success
      );
    } else {
      Get.snackbar(
        "Duplicate Request".tr,
        "You already have a pending request for this house.".tr,
        backgroundColor: Colors.orange.withValues(alpha: 0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.warning, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
      );
      _showResultDialog(
        title: "Request Exists".tr,
        message:
            "You have already sent a request for this house. Please wait for the owner's response."
                .tr,
        type: 2,
      );
    }
  }

  void _showResultDialog({
    required String title,
    required String message,
    required int type,
  }) {
    Color mainColor;
    IconData mainIcon;
    String buttonText;

    switch (type) {
      case 1:
        mainColor = Colors.green;
        mainIcon = Icons.check_circle;
        buttonText = "Great!".tr;
        break;
      case 2:
        mainColor = Colors.orange;
        mainIcon = Icons.warning_amber_rounded;
        buttonText = "I Understand".tr;
        break;
      default:
        mainColor = Colors.red;
        mainIcon = Icons.error_outline;
        buttonText = "Try Again".tr;
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(mainIcon, color: mainColor, size: 64),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Get.back();
                if (type == 1 || type == 2) {
                  Get.back();
                  Get.back();
                  Get.back();
                }
              },
              child: Text(
                buttonText,
                style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
  bool isPastDay(DateTime day) {
    final today = DateTime.now();
    final d = DateTime(day.year, day.month, day.day);
    final t = DateTime(today.year, today.month, today.day);
    return d.isBefore(t);
  }

  void _showInactiveAccountDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Account Not Activated".tr),
        content: Text(
          "Your account is not activated yet.\nPlease wait for admin approval."
              .tr,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: Text("OK".tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
