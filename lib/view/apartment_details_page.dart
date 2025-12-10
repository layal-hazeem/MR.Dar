import 'package:flutter/material.dart';
import '../model/apartment_model.dart';

class ApartmentDetailsPage extends StatelessWidget {
  final Apartment apartment;
  const ApartmentDetailsPage({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // ---------- زر الحجز (أسفل الشاشة) ----------
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, -3))
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF274668),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              // TODO: Navigate to booking process
            },
            child: Text(
              "Reserve Now",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- صور الشقة ----------
            SizedBox(
              height: 320,
              child: PageView(
                children: apartment.houseImages.isNotEmpty
                    ? apartment.houseImages
                    .map((img) =>
                    Image.network(img, fit: BoxFit.cover))
                    .toList()
                    : [
                  Image.asset(
                    'images/photo_2025-11-30_12-36-36.jpg',
                    fit: BoxFit.cover,
                  )
                ],
              ),
            ),

            // ---------- محتوى الصفحة ----------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- السعر ----------
                  Text(
                    "\$${apartment.rentValue} / night",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ---------- الموقع ----------
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: Colors.redAccent, size: 22),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${apartment.street}, City ID: ${apartment.cityId}",
                          style:
                          TextStyle(fontSize: 15, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ---------- معلومات الغرف والمساحة ----------
                  Row(
                    children: [
                      _infoIcon(Icons.bed, "${apartment.rooms} Beds"),
                      const SizedBox(width: 16),
                      _infoIcon(Icons.square_foot,
                          "${apartment.space.toString()} m²"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ---------- الوصف ----------
                  Text(
                    "Description",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    apartment.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ---------- الملاحظات ----------
                  if (apartment.notes.isNotEmpty) ...[
                    Text(
                      "Notes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      apartment.notes,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Widget للأيقونة + النص ----------
  Widget _infoIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 15, color: Colors.black87),
        )
      ],
    );
  }
}
