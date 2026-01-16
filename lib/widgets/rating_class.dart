import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 20,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index + 1 <= rating) {
          // full star
          return Icon(Icons.star, size: size, color: activeColor);
        } else if (index + 0.5 <= rating) {
          // half star
          return Icon(Icons.star_half, size: size, color: activeColor);
        } else {
          // empty star
          return Icon(Icons.star_border, size: size, color: inactiveColor);
        }
      }),
    );
  }
}
