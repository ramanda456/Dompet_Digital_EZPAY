import 'package:flutter/material.dart';

class GameBannerCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onTap;

  const GameBannerCard({
    super.key,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final Widget banner = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: width,
        height: width * 0.28,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: banner,
        ),
      );
    }

    return banner;
  }
}
