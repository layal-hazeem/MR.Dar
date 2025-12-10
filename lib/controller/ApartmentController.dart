import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/apartment_model.dart';
import '../service/ApartmentService.dart';
import 'package:new_project/view/apartment_details_page.dart';

class ApartmentController extends GetxController {
  final ApartmentService service;

  ApartmentController({required this.service});

  // البيانات
  RxList<Apartment> apartments = <Apartment>[].obs;

  // حالات الواجهة
  RxBool isLoading = false.obs;
  RxBool isCreating = false.obs; // حالة إنشاء شقة جديدة
  RxString errorMessage = ''.obs;
  RxString createMessage = ''.obs; // رسالة نتيجة الإنشاء

  // فلترة
  Rxn<int> cityId = Rxn<int>();
  Rxn<int> minPrice = Rxn<int>();
  Rxn<int> maxPrice = Rxn<int>();

  // ========================= تحميل كل الشقق =========================
  Future<void> loadApartments() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final data = await service.getAllApartments();
      apartments.assignAll(data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ========================= إنشاء شقة جديدة =========================
  Future<bool> createApartment({
    required String title,
    required String description,
    required double rentValue,
    required int rooms,
    required double space,
    required String notes,
    required int governorateId,
    required int? cityId,
    required String street,
    required int flatNumber,
    required int? longitude,
    required int? latitude,
    required List<XFile> houseImages,
  }) async {
    try {
      isCreating.value = true;
      createMessage.value = "";

      final response = await service.createApartment(
        title: title,
        description: description,
        rentValue: rentValue,
        rooms: rooms,
        space: space,
        notes: notes,
        governorateId: governorateId,
        cityId: cityId,
        street: street,
        flatNumber: flatNumber,
        longitude: longitude,
        latitude: latitude,
        houseImages: houseImages,
      );

      // تحديث القائمة بعد الإضافة الناجحة
      await loadApartments();

      createMessage.value = "تم إنشاء الشقة بنجاح!";
      return true;

    } catch (e) {
      createMessage.value = "خطأ في إنشاء الشقة: $e";
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  // ========================= البحث =========================
  Future<void> search(String keyword) async {
    if (keyword.trim().isEmpty) {
      loadApartments();
      return;
    }

    isLoading.value = true;

    final data = await service.searchApartments(keyword);
    apartments.assignAll(data);

    isLoading.value = false;
  }

  // ========================= تطبيق الفلاتر =========================
  Future<void> applyFilters() async {
    isLoading.value = true;

    final data = await service.filterApartments(
      cityId: cityId.value,
      minPrice: minPrice.value,
      maxPrice: maxPrice.value,
    );

    apartments.assignAll(data);

    isLoading.value = false;
  }

  @override
  void onInit() {
    loadApartments();
    super.onInit();
  }
}