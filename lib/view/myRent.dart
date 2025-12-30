import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/my_rents_controller.dart';
import '../core/enums/reservation_status.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';

class MyRent extends StatefulWidget {
  const MyRent({super.key});

  @override
  State<MyRent> createState() => _MyRentState();
}

class _MyRentState extends State<MyRent> {
  final MyRentsController controller = Get.find<MyRentsController>();

  @override
  Widget build(BuildContext context) {
    print("🎨 UI rebuild, reservations = ${controller.allReservations.length}");
    print('🎨 UI using controller ${controller.hashCode}');
    return Scaffold(
      body: Column(
        children: [
          // ----------- Status Tabs -----------
          Obx(
                () => SingleChildScrollView(

              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: ReservationStatus.values.map((status) {
                  final isSelected =
                      controller.currentStatus.value == status;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(status.displayName),
                      selected: isSelected,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // غيّري الرقم حسب الدرجة اللي تحبيها
                      ),
                      onSelected: (_) => controller.changeStatus(status),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ----------- Reservation List -----------
          Expanded(
            child: Obx(() {
              print('🎨 rebuild with ${controller.allReservations.length}');

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

              final reservations = controller.filteredReservations;

              // 3️⃣ Empty
              if (reservations.isEmpty) {
                return Center(
                  child: Text(
                    'no ${controller.currentStatus.value.displayName} reservations',
                  ),
                );
              }

              // 4️⃣ List
              return ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final reservation = reservations[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ApartmentCard(
                      apartment: reservation.apartment,
                      onTap: () {
                        Get.to(
                              () => ApartmentDetailsPage(
                            apartment: reservation.apartment,
                          ),
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