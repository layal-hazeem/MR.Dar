import 'package:get/get.dart';

import '../model/apartment_model.dart';
import '../core/enums/apartment_status.dart';
import '../service/ApartmentService.dart';

class MyApartmentsController extends GetxController {
  final ApartmentService apartmentService;

  MyApartmentsController({required this.apartmentService});

  /// جميع الشقق
  final RxList<Apartment> allApartments = <Apartment>[].obs;

  /// الحالة الحالية المختارة
  final Rx<ApartmentStatus> currentStatus =
      ApartmentStatus.pending.obs;

  /// حالات الواجهة
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyApartments();
  }
  //تغيير الحالة المختارة
  void changeStatus(ApartmentStatus status) {
    currentStatus.value = status;
  }

  /// جلب شقق المالك من السيرفر
  Future<void> fetchMyApartments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final apartments = await apartmentService.getMyApartments();
      allApartments.assignAll(apartments);
    } catch (e) {
      errorMessage.value = 'load apartments failed';
    } finally {
      isLoading.value = false;
    }
  }

  /// فلترة الشقق حسب الحالة
  List<Apartment> get filteredApartments {
    return allApartments.where((apartment) {
      final status = ApartmentStatusExtension.fromString(
        apartment.apartmentStatus,
      );
      return status == currentStatus.value;
    }).toList();
  }

  void setApartments(List<Apartment> apartments) {
    allApartments.assignAll(apartments);
  }

  void clearApartments() {
    allApartments.clear();
  }
}
