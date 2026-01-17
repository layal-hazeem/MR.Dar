import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/view/rate_apartment_page.dart';
import '../controller/my_rents_controller.dart';
import '../core/enums/reservation_status.dart';
import '../model/reservation_model.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';

class MyRent extends StatefulWidget {
  const MyRent({super.key});

  @override
  State<MyRent> createState() => _MyRentState();
}

class _MyRentState extends State<MyRent> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = controller.highlightedReservationId.value;

      if (id != null) {
        controller.scrollToReservation(id);
      }
    });
  }

  final MyRentsController controller = Get.find<MyRentsController>();

  @override
  Widget build(BuildContext context) {
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
                  final isSelected = controller.currentStatus.value == status;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(status.displayName),
                      selected: isSelected,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
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

          // ----------- Reservation List -----------
          Expanded(
            child: Obx(() {
              //  Loading
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Error
              if (controller.errorMessage.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }

              final reservations = controller.filteredReservations;

              //  Empty
              if (reservations.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchMyReservations();
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: Text(
                            "${'no reservations'.tr} ${controller.currentStatus.value.displayName.tr}",
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              //List
              return RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchMyReservations();
                },
                child: ListView.builder(
                  controller: controller.scrollController,

                  physics: const AlwaysScrollableScrollPhysics(),

                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = reservations[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Get.to(
                                () => ApartmentDetailsPage(
                                  apartment: reservation.apartment,
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ---------- Image ----------
                                  if (reservation
                                      .apartment
                                      .houseImages
                                      .isNotEmpty)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: Image.network(
                                        reservation.apartment.houseImages.first,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ---------- Apartment title ----------
                                        Text(
                                          reservation.apartment.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        // ---------- Dates ----------
                                        Text(
                                          "From ${reservation.startDate} → ${reservation.endDate}",
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        // ---------- Owner ----------
                                        if (reservation.user != null)
                                          Text(
                                            "Owner: ${reservation.user!.firstName} ${reservation.user!.lastName}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),

                                        const SizedBox(height: 10),

                                        // ---------- Status ----------
                                        Row(
                                          children: [
                                            const Text("Status: "),
                                            Text(
                                              reservation.status.tr,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    reservation.status ==
                                                        'accepted'
                                                    ? Colors.green
                                                    : reservation.status ==
                                                          'pending'
                                                    ? Colors.orange
                                                    : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (controller.currentStatus.value ==
                              ReservationStatus.previous)
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Get.to(
                                    () => RateApartmentPage(
                                      houseId: reservation.apartment.id,
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                label: const Text(
                                  "Rate",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.surface,
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  shadowColor: Colors.black.withValues(
                                    alpha: 0.3,
                                  ),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          if (controller.currentStatus.value ==
                              ReservationStatus.pending)
                            _buildPendingActions(reservation),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingActions(ReservationModel reservation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: () => controller.editReservation(reservation),
            icon: const Icon(Icons.edit, size: 16),
            label: Text("Edit".tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),

          const SizedBox(width: 8),

          ElevatedButton.icon(
            onPressed: () => _showCancelDialog(reservation.id),
            icon: const Icon(Icons.close, size: 16),
            label: Text("CANCEL".tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(int reservationId) {
    Get.defaultDialog(
      title: "Cancel Reservation".tr,
      middleText: "Are you sure you want to cancel this reservation?".tr,
      textConfirm: "Yes, Cancel".tr,
      textCancel: "No".tr,
      buttonColor: Theme.of(context).colorScheme.error,
      confirmTextColor: Theme.of(context).colorScheme.onError,
      onConfirm: () {
        Get.back();
        controller.cancelReservation(reservationId);
      },
    );
  }
}
