// تصميم مبسط لـ apartment_card.dart
import 'package:flutter/material.dart';
import '../model/apartment_model.dart';

class ApartmentCard extends StatelessWidget {
  final Apartment apartment;

  const ApartmentCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصورة
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            child: Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey[200],
              child: apartment.houseImages.isNotEmpty
                  ? Image.network(
                apartment.houseImages[0],
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.home, size: 40, color: Colors.grey),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  apartment.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  '\$${apartment.rentValue}',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(Icons.bed, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('${apartment.rooms} beds'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}