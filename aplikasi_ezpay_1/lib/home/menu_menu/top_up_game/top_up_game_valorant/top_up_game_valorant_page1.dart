import 'package:flutter/material.dart';
import '../pembayaran_game/pembayaran_game.dart';
import 'widgets/diamond_card_widget.dart';
import 'widgets/big_diamond_option_widget.dart';

class TopUpGameValorantPage1 extends StatefulWidget {
  const TopUpGameValorantPage1({super.key});

  @override
  State<TopUpGameValorantPage1> createState() => _TopUpGameValorantPage1State();
}

class _TopUpGameValorantPage1State extends State<TopUpGameValorantPage1> {
  final TextEditingController _idController = TextEditingController();
  int? _selectedIndex;

  // Daftar item Valorant Point (VP)
  final List<Map<String, String>> vpList = [
    {'image': 'assets/image/valorant_vp.png', 'text': '475 VP'},
    {'image': 'assets/image/valorant_vp.png', 'text': '1000 VP'},
    {'image': 'assets/image/valorant_vp.png', 'text': '1475 VP'},
    {'image': 'assets/image/valorant_vp.png', 'text': '3650 VP'},
    {'image': 'assets/image/valorant_vp.png', 'text': '3654 VP'},
    {'image': 'assets/image/valorant_vp.png', 'text': '4125 VP'},
    {'image': 'assets/image/valorant_vp.png', 'text': '6350 VP'},
    {'image': 'assets/image/valorant_vp.png', 'text': '8700 VP'},
    {'image': 'assets/image/valorant_vp.png', 'text': '7300 VP'},
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
                  // BIG OPTIONS (Battlepass & Flash Sale)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: BigDiamondOptionWidget(
                          title: "Battlepass (1080 VP)",
                          gradientColors: [
                            Colors.redAccent,
                            Colors.deepOrange,
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BigDiamondOptionWidget(
                          title: "1135 VP",
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

                  // GRID VIEW Valorant Points
                  GridView.builder(
                    itemCount: vpList.length,
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
                      final item = vpList[index];
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
                              content: Text("Pilih salah satu paket VP terlebih dahulu"),
                            ),
                          );
                          return;
                        }
                        if (_idController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Masukkan ID Game terlebih dahulu"),
                            ),
                          );
                          return;
                        }

                        // navigasi ke halaman pembayaran
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PembayaranMobileLegendPage(
                              idGame: _idController.text,
                              paketDiamond: vpList[_selectedIndex!]['text']!,
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
