import 'package:flutter/material.dart';
import '../pembayaran_game/pembayaran_game.dart';
import 'widgets/diamond_card_widget.dart';
import 'widgets/big_diamond_option_widget.dart';

class TopUpGameFatePage1 extends StatefulWidget {
  const TopUpGameFatePage1({super.key});

  @override
  State<TopUpGameFatePage1> createState() => _TopUpGameFatePage1State();
}

class _TopUpGameFatePage1State extends State<TopUpGameFatePage1> {
  final TextEditingController _idController = TextEditingController();
  int? _selectedIndex;

  // Daftar Magic Shard untuk game FATE
  final List<Map<String, String>> shardList = [
    {'image': 'assets/image/magic_shard.png', 'text': '60 Magic Shard'},
    {'image': 'assets/image/magic_shard.png', 'text': '300 Magic Shard'},
    {'image': 'assets/image/magic_shard.png', 'text': '980 Magic Shard'},
    {'image': 'assets/image/magic_shard.png', 'text': '1980 Magic Shard'},
    {'image': 'assets/image/magic_shard.png', 'text': '3280 Magic Shard'},
    {'image': 'assets/image/magic_shard.png', 'text': '6480 Magic Shard'},
    {'image': 'assets/image/magic_shard.png', 'text': 'Blessing Pack'},
    {'image': 'assets/image/magic_shard.png', 'text': 'Traveler Pack'},
    {'image': 'assets/image/magic_shard.png', 'text': 'Premium Bundle'},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          // =================== HEADER ===================
          Container(
            width: double.infinity,
            height: size.height * 0.22,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _idController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Masukan ID Game:',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // =================== KONTEN ===================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // BIG OPTIONS (Welkin & Flash Sale)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: BigDiamondOptionWidget(
                          title: "Welkin Rp80.000",
                          gradientColors: [
                            Colors.purpleAccent,
                            Colors.indigo,
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BigDiamondOptionWidget(
                          title: "1650 Magic Shard",
                          gradientColors: [
                            Colors.grey,
                            Colors.blueAccent,
                          ],
                          flashSale: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // GRID VIEW Magic Shard
                  GridView.builder(
                    itemCount: shardList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final item = shardList[index];
                      final isSelected = _selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedIndex = index);
                        },
                        child: DiamondCardWidget(
                          image: item['image']!,
                          text: item['text']!,
                          isSelected: isSelected,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // =================== BUTTON SELANJUTNYA ===================
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedIndex == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Pilih salah satu paket Magic Shard terlebih dahulu"),
                            ),
                          );
                          return;
                        }
                        if (_idController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Masukkan ID Game terlebih dahulu"),
                            ),
                          );
                          return;
                        }

                        // Navigasi ke halaman pembayaran
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PembayaranMobileLegendPage(
                              idGame: _idController.text,
                              paketDiamond: shardList[_selectedIndex!]['text']!,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2962FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Selanjutnya",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
