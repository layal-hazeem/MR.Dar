import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../model/apartment_model.dart';
import '../core/enums/apartment_status.dart';
import '../service/apartment_service.dart';

class MyApartmentsController extends GetxController {
  final ApartmentService apartmentService;

  MyApartmentsController({required this.apartmentService});

  //all apartments
  final RxList<Apartment> allApartments = <Apartment>[].obs;

  final Rx<ApartmentStatus> currentStatus = ApartmentStatus.pending.obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyApartments();
  }

  void changeStatus(ApartmentStatus status) {
    currentStatus.value = status;
  }

  Future<void> fetchMyApartments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final apartments = await apartmentService.getMyApartments();
      allApartments.assignAll(apartments);
      update();
      debugPrint('Total apartments fetched: ${allApartments.length}');
      for (var apt in allApartments) {
        debugPrint('Apartment ${apt.id}: status = ${apt.apartmentStatus}');
      }
    } catch (e) {
      errorMessage.value = 'load apartments failed'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  List<Apartment> get filteredApartments {
    return allApartments.where((apartment) {
      final status = ApartmentStatusExtension.fromDynamic(
        apartment.apartmentStatus,
      );
      return status == currentStatus.value;
    }).toList();
  }

  int getApartmentCountByStatus(ApartmentStatus status) {
    return allApartments.where((apartment) {
      final aptStatus = ApartmentStatusExtension.fromDynamic(
        apartment.apartmentStatus,
      );
      return aptStatus == status;
    }).length;
  }

  void updateApartments(List<Apartment> apartments) {
    allApartments.assignAll(apartments);
  }

  void clearApartments() {
    allApartments.clear();
  }

  Apartment? getApartmentById(int id) {
    return allApartments.firstWhereOrNull((apt) => apt.id == id);
  }

  void updateApartmentStatus(int apartmentId, ApartmentStatus newStatus) {
    final index = allApartments.indexWhere((apt) => apt.id == apartmentId);
    if (index != -1) {
      // Note: Since Apartment is immutable, we need to create a new instance
      final oldApartment = allApartments[index];
      final updatedApartment = Apartment(
        id: oldApartment.id,
        title: oldApartment.title,
        description: oldApartment.description,
        rentValue: oldApartment.rentValue,
        rooms: oldApartment.rooms,
        space: oldApartment.space,
        notes: oldApartment.notes,
        cityId: oldApartment.cityId,
        cityName: oldApartment.cityName,
        governorateId: oldApartment.governorateId,
        governorateName: oldApartment.governorateName,
        street: oldApartment.street,
        flatNumber: oldApartment.flatNumber,
        longitude: oldApartment.longitude,
        latitude: oldApartment.latitude,
        houseImages: oldApartment.houseImages,
        apartmentStatus: newStatus.toString().split('.').last,
      );
      allApartments[index] = updatedApartment;
      allApartments.refresh();
      update();
    }
  }

  Future<void> reload() async {
    await fetchMyApartments();
  }
}
