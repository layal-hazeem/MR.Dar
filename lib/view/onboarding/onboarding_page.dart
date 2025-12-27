import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final Widget? bottomWidget;
  final double imageHeight;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    this.bottomWidget,
    this.imageHeight = 350,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: imageHeight, fit: BoxFit.contain),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF274668),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 40),
          if (bottomWidget != null) bottomWidget!,
        ],
      ),
    );
  }
}
