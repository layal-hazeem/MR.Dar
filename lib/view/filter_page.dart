import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/apartment_controller.dart';
import '../model/filter_model.dart';

class FilterPage extends StatelessWidget {
  FilterPage({super.key});

  final ApartmentController controller = Get.find<ApartmentController>();

  final Rx<RangeValues> rentRange = Rx(RangeValues(0, 5000));
  final Rx<RangeValues> roomsRange = Rx(RangeValues(1, 10));
  final Rx<RangeValues> spaceRange = Rx(RangeValues(0, 500));
  final TextEditingController searchController = TextEditingController();

  final RxString selectedSortBy = RxString('created_at'.tr);
  final RxString selectedSortDir = RxString('asc'.tr);
  final RxList<Map<String, dynamic>> sortOptionsFromApi = RxList([]);

  final RxInt selectedGovernorateId = RxInt(0);
  final RxInt selectedCityId = RxInt(0);

  final RxList<Map<String, dynamic>> filteredCities = RxList([]);

  final Map<String, String> sortOptions = {
    'created_at'.tr: 'Newest'.tr,
    'Rooms'.tr: 'Rooms'.tr,
    'Space'.tr: 'Space'.tr,
    'rent_value'.tr: 'Rent Asc'.tr,
    'Rent Desc'.tr: 'Rent Desc'.tr,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Apartment Filters".tr,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: Text(
              "Clear All".tr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // search
                    _buildSearchSection(context),
                    const Divider(height: 30),

                    // sort
                    _buildSortSection(context),
                    const Divider(height: 30),

                    // location
                    _buildLocationSection(context),
                    const Divider(height: 30),

                    // rent range
                    _buildRangeSection(
                      context,
                      title: "Rent Range (\$)".tr,
                      range: rentRange,
                      min: 0,
                      max: 5000,
                      divisions: 50,
                      unit: '\$'.tr,
                    ),
                    const SizedBox(height: 20),

                    // rooms range
                    _buildRangeSection(
                      context,
                      title: "Rooms Number".tr,
                      range: roomsRange,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      unit: 'Rooms'.tr,
                    ),
                    const SizedBox(height: 20),

                    // space range
                    _buildRangeSection(
                      context,
                      title: "Space Range (m²)".tr,
                      range: spaceRange,
                      min: 0,
                      max: 500,
                      divisions: 25,
                      unit: 'm²'.tr,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Search".tr,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: "Search by name or description".tr,
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
            ),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => searchController.clear(),
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildSortSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sort By".tr,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Obx(
          () => RadioGroup<String>(
            groupValue: selectedSortBy.value,
            onChanged: (String? value) {
              if (value != null) {
                selectedSortBy.value = value;

                if (value == 'rent_value') {
                  selectedSortDir.value = 'asc'.tr;
                } else if (value == 'rent_desc') {
                  selectedSortDir.value = 'desc'.tr;
                }
              }
            },
            child: Column(
              children: sortOptions.entries.map((entry) {
                return RadioListTile<String>(
                  title: Text(
                    entry.value,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  value: entry.key,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  activeColor: Theme.of(context).colorScheme.primary,
                );
              }).toList(),
            ),
          ),
        ),

        Obx(() {
          final shouldShowSortDir =
              selectedSortBy.value == 'Rooms'.tr ||
              selectedSortBy.value == 'Space'.tr ||
              selectedSortBy.value == 'created_at'.tr;

          if (!shouldShowSortDir) return const SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Order Direction".tr,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              RadioGroup<String>(
                groupValue: selectedSortDir.value,
                onChanged: (value) => selectedSortDir.value = value!,
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Ascending'.tr),
                        value: 'asc'.tr,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Descending'.tr),
                        value: 'desc'.tr,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Location Filter".tr,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => DropdownButtonFormField<int>(
                initialValue: selectedGovernorateId.value == 0
                    ? null
                    : selectedGovernorateId.value,
                decoration: InputDecoration(
                  labelText: "Select Governorate".tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(
                    Icons.location_city,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                items: [
                  DropdownMenuItem<int>(
                    value: 0,
                    child: Text("All Governorates".tr),
                  ),
                  ...controller.governorates.map((gov) {
                    return DropdownMenuItem<int>(
                      value: gov.id,
                      child: Text(gov.name),
                    );
                  }),
                ],
                onChanged: (int? value) {
                  selectedGovernorateId.value = value ?? 0;
                  selectedCityId.value = 0;

                  if (value == null || value == 0) {
                    filteredCities.clear();
                    return;
                  }

                  final gov = controller.governorates.firstWhere(
                    (g) => g.id == value,
                  );

                  filteredCities.value = gov.cities
                      .map((c) => {'id'.tr: c.id, 'name'.tr: c.name})
                      .toList();
                },
              ),
            ),
            const SizedBox(height: 15),

            Obx(
              () => DropdownButtonFormField<int>(
                initialValue: selectedCityId.value == 0
                    ? null
                    : selectedCityId.value,
                decoration: InputDecoration(
                  labelText: "Select City".tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                items: [
                  DropdownMenuItem<int>(value: 0, child: Text("All Cities".tr)),
                  ...filteredCities.map((city) {
                    return DropdownMenuItem<int>(
                      value: city['id'.tr],
                      child: Text(city['name'.tr]),
                    );
                  }),
                ],
                onChanged: (int? value) => selectedCityId.value = value ?? 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRangeSection(
    BuildContext context, {
    required String title,
    required Rx<RangeValues> range,
    required double min,
    required double max,
    required int divisions,
    required String unit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Column(
            children: [
              RangeSlider(
                values: range.value,
                min: min,
                max: max,
                divisions: divisions,
                labels: RangeLabels(
                  '${range.value.start.round()} $unit',
                  '${range.value.end.round()} $unit',
                ),
                activeColor: Theme.of(context).colorScheme.primary,
                inactiveColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.3),
                onChanged: (RangeValues values) => range.value = values,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: Text('Min: ${range.value.start.round()} $unit'.tr),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Chip(
                      label: Text('Max: ${range.value.end.round()} $unit'.tr),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _resetFilters,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(55),
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            child: Text(
              "Reset All".tr,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(55),
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: Text(
              "Apply Filters".tr,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _resetFilters() {
    rentRange.value = const RangeValues(0, 5000);
    roomsRange.value = const RangeValues(1, 10);
    spaceRange.value = const RangeValues(0, 500);
    searchController.clear();
    selectedGovernorateId.value = 0;
    selectedCityId.value = 0;
    selectedSortBy.value = 'created_at'.tr;
    selectedSortDir.value = 'asc'.tr;
    filteredCities.value = [];

    controller.resetFilter();
  }

  void _applyFilters() {
    String finalSortBy = selectedSortBy.value;
    if (selectedSortBy.value == 'rent_desc'.tr) {
      finalSortBy = 'rent_value'.tr;
    }

    final FilterModel filter = FilterModel(
      search: searchController.text.trim().isEmpty
          ? null
          : searchController.text.trim(),
      governorateId: selectedGovernorateId.value == 0
          ? null
          : selectedGovernorateId.value,
      cityId: selectedCityId.value == 0 ? null : selectedCityId.value,
      minRent: rentRange.value.start.round(),
      maxRent: rentRange.value.end.round(),
      minRooms: roomsRange.value.start.round(),
      maxRooms: roomsRange.value.end.round(),
      minSpace: spaceRange.value.start.round(),
      maxSpace: spaceRange.value.end.round(),
      sortBy: finalSortBy,
      sortDir: selectedSortDir.value,
    );

    controller.applyFilter(filter);
    Get.back();
  }
}
