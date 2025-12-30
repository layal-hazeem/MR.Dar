import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/my_apartments_controller.dart';
import '../core/enums/apartment_status.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';

class MyApartments extends StatefulWidget {
  const MyApartments({super.key});

  @override
  State<MyApartments> createState() => _MyApartmentsState();
}

class _MyApartmentsState extends State<MyApartments> {
  final MyApartmentsController controller = Get.find<MyApartmentsController>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // -------- Status Tabs --------
          Obx(
                () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: ApartmentStatus.values.map((status) {
                  final isSelected =
                      controller.currentStatus.value == status;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(status.displayName),
                      selected: isSelected,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onSelected: (_) => controller.changeStatus(status),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // -------- Apartments List --------
          Expanded(
            child: Obx(() {
              // 1️⃣ Loading
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // 2️⃣ Error
              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(controller.errorMessage.value),
                );
              }

              final apartments = controller.filteredApartments;

              // 3️⃣ Empty
              if (apartments.isEmpty) {
                return Center(
                  child: Text(
                    'no apartments in ${controller.currentStatus.value.displayName}',
                  ),
                );
              }

              // 4️⃣ List
              return ListView.builder(
                itemCount: apartments.length,
                itemBuilder: (context, index) {
                  final apartment = apartments[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ApartmentCard(
                      apartment: apartment,
                      onTap: () {
                        Get.to(
                              () => ApartmentDetailsPage(apartment: apartment),
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}