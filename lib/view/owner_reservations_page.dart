import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/owner_reservations_controller.dart';

class OwnerReservationsPage extends StatelessWidget {
  final controller = Get.find<OwnerReservationsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // تصنيف الحجوزات حسب الحالة
      final pending = controller.reservations.where((r) => r.status == 'pending').toList();
      final accepted = controller.reservations.where((r) => r.status == 'accepted').toList();
      final rejected = controller.reservations.where((r) => r.status == 'rejected').toList();

      return DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              tabs:  [
                Tab(text: 'Pending'.tr),
                Tab(text: 'accepted'.tr),
                Tab(text: 'Rejected'.tr),
              ],
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(pending),
                  _buildList(accepted),
                  _buildList(rejected),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildList(List reservations) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.loadReservations();
      },
      child: reservations.isEmpty
          ? ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children:  [
          SizedBox(height: 200),
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
                      Text("Renter: ${r.user.firstName} ${r.user.lastName}".tr),
                      Text("Phone: ${r.user.phone}".tr),
                      const SizedBox(height: 8),

                      if (r.status == 'Pending'.tr)
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
                              child:  Text("Reject".tr),
                            ),
                          ],
                        )
                      else
                        Text(
                          "Status: ${r.status}".tr,
                          style: TextStyle(
                            color: r.status == 'accepted'.tr
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
