import 'package:flutter/material.dart';

import 'widgets/game_banner_card.dart';
import 'top_up_game_mobile_legends/top_up_game_mobile_legend_page1.dart';
import 'top_up_game_freefire/top_up_game_freefire_page1.dart';
import 'top_up_game_valorant/top_up_game_valorant_page1.dart';
import 'top_up_game_starrail/top_up_game_starrail_page1.dart';
import 'top_up_game_fate/top_up_game_fate_page1.dart';

class TopUpGamePage extends StatelessWidget {
  const TopUpGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
              ),
            ),
          ),
          Positioned(
            top: h * 0.38,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Top Up Game',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    GameBannerCard(
                      imagePath: 'assets/image/freefire_banner.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TopUpGameFreeFirePage1(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    GameBannerCard(
                      imagePath: 'assets/image/mobilelegends_banner.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TopUpGameMobileLegendPage1(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    GameBannerCard(
                      imagePath: 'assets/image/valorant_banner.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TopUpGameValorantPage1(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    GameBannerCard(
                      imagePath: 'assets/image/starrail_banner.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TopUpGameStarRailPage1(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    GameBannerCard(
                      imagePath: 'assets/image/fate_banner.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TopUpGameFatePage1(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
