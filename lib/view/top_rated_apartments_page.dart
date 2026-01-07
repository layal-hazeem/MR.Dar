import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';

class TopRatedApartmentsPage extends StatelessWidget {
  TopRatedApartmentsPage({super.key});

  final ApartmentController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Top Rated".tr,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final apartments = controller.topRatedApartments;

        if (apartments.isEmpty) {
          return Center(
            child: Text(
              "No top rated apartments available".tr,
              style: TextStyle(
                fontSize: 16,
                color:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: apartments.length,
          itemBuilder: (context, index) {
            final apt = apartments[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: ApartmentCard(
                apartment: apt,
                onTap: () {
                  Get.to(
                        () => ApartmentDetailsPage(apartment: apt),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
