import 'package:flutter/material.dart';

class BigDiamondOptionWidget extends StatelessWidget {
  final String title;
  final List<Color> gradientColors;
  final bool flashSale;

  const BigDiamondOptionWidget({
    super.key,
    required this.title,
    required this.gradientColors,
    this.flashSale = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          if (flashSale)
            const Positioned(
              top: 6,
              right: 8,
              child: Text(
                "FLASH SALE",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
