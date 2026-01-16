import 'package:get/get.dart';

import '../model/owner_reservation_model.dart';
import '../service/booking_service.dart';
import 'notification_controller.dart';

class OwnerReservationsController extends GetxController {
  final BookingService service;

  OwnerReservationsController({required this.service});

  var isLoading = false.obs;
  var reservations = <OwnerReservation>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReservations();
  }

  Future<void> loadReservations() async {
    isLoading.value = true;
    reservations.value = await service.getOwnerReservations();
    isLoading.value = false;
  }

  Future<void> acceptReservation(int id) async {
    final success = await service.acceptReservation(id);
    if (success) {
      reservations.removeWhere((r) => r.id == id);
      Get.snackbar("Success".tr, "Reservation accepted".tr);
    }
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().fetchNotifications();
    }
  }

  Future<void> rejectReservation(int id) async {
    final success = await service.rejectReservation(id);
    if (success) {
      reservations.removeWhere((r) => r.id == id);
      Get.snackbar("Rejected".tr, "Reservation rejected".tr);
    }
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().fetchNotifications();
    }
  }
}
