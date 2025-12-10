import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  final ApartmentController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- Search Bar ----------------
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3))
              ],
            ),
            child: TextField(
              onChanged: (value) => controller.search(value),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                hintText: "Search apartments...",
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ---------------- Content ----------------
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    "Oops: ${controller.errorMessage.value}",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              }

              if (controller.apartments.isEmpty) {
                return Center(
                  child: Text(
                    "No apartments available",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                );
              }

              // ---------------- Grid View Cards ----------------
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemCount: controller.apartments.length,
                itemBuilder: (context, index) {
                  final apt = controller.apartments[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                            () => ApartmentDetailsPage(apartment: apt),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 200),
                      );
                    },
                    // ✅ التصحيح هنا: استخدم ApartmentCard وليس ApartmentDetailsPage
                    child: ApartmentCard(apartment: apt, onTap: () {  },),
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