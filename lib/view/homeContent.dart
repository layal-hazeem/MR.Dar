import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../model/apartment_model.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  final ApartmentController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
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
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
              //  onChanged: (value) => controller.search(value),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  hintText: "Search apartments...",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ---------------- قسم: الشقق المميزة (أفقي) ----------------
        Obx(() {
          if (controller.featuredApartments.isEmpty) return SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Featured Apartments",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.featuredApartments.length,
                  itemBuilder: (context, index) {
                    final apt = controller.featuredApartments[index];
                    return Container(
                      width: 220,
                      margin: EdgeInsets.only(right: 16),
                      child: FeaturedApartmentCard(
                        apartment: apt,
                        onTap: () {
                          Get.to(() => ApartmentDetailsPage(apartment: apt));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),


        const SizedBox(height: 30),

            // ---------------- قسم: الأعلى تقييماً (أفقي) ----------------
        Obx(() {
          if (controller.topRatedApartments.isEmpty) return SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Top Rated",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.topRatedApartments.length,
                  itemBuilder: (context, index) {
                    final apt = controller.topRatedApartments[index];
                    return Container(
                      width: 220,
                      margin: EdgeInsets.only(right: 16),
                      child: FeaturedApartmentCard(
                        apartment: apt,
                        onTap: () {
                          Get.to(() => ApartmentDetailsPage(apartment: apt));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),


        const SizedBox(height: 30),

         ],
        ),
      ),
    );
  }
}

// كارد خاص للأقسام الأفقية
class FeaturedApartmentCard extends StatelessWidget {
  final Apartment apartment;
  final VoidCallback onTap;

  const FeaturedApartmentCard({
    super.key,
    required this.apartment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: apartment.houseImages.isNotEmpty
                  ? Image.network(
                apartment.houseImages[0],
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Container(
                height: 100,
                color: Colors.grey[200],
                child: Center(
                  child: Icon(Icons.home, size: 50, color: Colors.grey),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apartment.title.length > 25
                        ? apartment.title.substring(0, 25) + "..."
                        : apartment.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "City ${apartment.cityId}",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "\$${apartment.rentValue} / night",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green[700],
                    ),
                  ),

                  const SizedBox(height: 8),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}