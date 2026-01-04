import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/review_controller.dart';

class RateApartmentPage extends StatelessWidget {
  final int houseId;

  RateApartmentPage({required this.houseId, super.key});

  final ReviewController controller = Get.put(
    ReviewController(service: Get.find()),
  );

  @override
  Widget build(BuildContext context) {
    controller.checkIfCanRate(houseId);

    return Scaffold(
      appBar: AppBar(title: Text("Rate Apartment")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (!controller.canRate.value) {
          return Center(child: Text("You cannot rate this apartment"));
        }

        return Column(
          children: [
            Text("Your rating"),
            Slider(
              value: controller.rating.value.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: controller.rating.value.toString(),
              onChanged: (v) => controller.rating.value = v.toInt(),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await controller.submitReview(houseId);

                if (success) {
                  Get.back();
                  Get.snackbar("Success", "Review added");
                }
              },
              child: Text("Submit"),
            ),
          ],
        );
      }),
    );
  }
}
