import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/owner_reservations_controller.dart';

class OwnerReservationsPage extends StatelessWidget {
  const OwnerReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerReservationsController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // Sort reservations per state - using constant strings for logic
      final pending = controller.reservations
          .where((r) => r.status == 'pending')
          .toList();
      final accepted = controller.reservations
          .where((r) => r.status == 'accepted')
          .toList();
      final rejected = controller.reservations
          .where((r) => r.status == 'rejected')
          .toList();

      return DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Pending'.tr),
                Tab(text: 'Accepted'.tr),
                Tab(text: 'Rejected'.tr),
              ],
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(context, controller, pending),
                  _buildList(context, controller, accepted),
                  _buildList(context, controller, rejected),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildList(
    BuildContext context,
    OwnerReservationsController controller,
    List reservations,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.loadReservations();
      },
      child: reservations.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 200),
                Center(child: Text("No bookings".tr)),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final r = reservations[index];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (r.house.images.isNotEmpty)
                        Image.network(
                          r.house.images.first,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.house.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("From ${r.startDate} → ${r.endDate}".tr),
                            Text(
                              "Renter: ${r.user.firstName} ${r.user.lastName}"
                                  .tr,
                            ),
                            Text("Phone: ${r.user.phone}".tr),
                            const SizedBox(height: 8),

                            if (r.status == 'pending')
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await controller.acceptReservation(r.id);
                                    },
                                    child: Text("Accept".tr),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await controller.rejectReservation(r.id);
                                    },
                                    child: Text("Reject".tr),
                                  ),
                                ],
                              )
                            else
                              Text(
                                "Status: ${r.status}".tr,
                                style: TextStyle(
                                  color: r.status == 'accepted'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
