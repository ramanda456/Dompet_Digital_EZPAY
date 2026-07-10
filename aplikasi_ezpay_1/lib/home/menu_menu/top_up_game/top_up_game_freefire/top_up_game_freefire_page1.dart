import 'package:flutter/material.dart';
import '../pembayaran_game/pembayaran_game.dart';
import 'widgets/diamond_card_widget.dart';
import 'widgets/big_diamond_option_widget.dart';

class TopUpGameFreeFirePage1 extends StatefulWidget {
  const TopUpGameFreeFirePage1({super.key});

  @override
  State<TopUpGameFreeFirePage1> createState() =>
      _TopUpGameFreeFirePage1State();
}

class _TopUpGameFreeFirePage1State extends State<TopUpGameFreeFirePage1> {
  final TextEditingController _idController = TextEditingController();
  int? _selectedIndex;

  // daftar diamond untuk Free Fire
  final List<Map<String, String>> diamondList = [
    {'image': 'assets/image/diamond.png', 'text': '70 Diamond'},
    {'image': 'assets/image/diamond.png', 'text': '140 Diamond'},
    {'image': 'assets/image/diamond.png', 'text': '200 Diamond'},
    {'image': 'assets/image/diamond.png', 'text': '420 Diamond'},
    {'image': 'assets/image/diamond.png', 'text': '860 Diamond'},
    {'image': 'assets/image/diamond.png', 'text': '1080 Diamond'},
    {'image': 'assets/image/diamond.png', 'text': '1798 Diamond'},
    {'image': 'assets/image/diamond.png', 'text': '2056 Diamond'},
    {'image': 'assets/image/diamond.png', 'text': '5900 Diamond'},
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  // BIG OPTIONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: BigDiamondOptionWidget(
                          title: "Monthly Membership Card",
                          gradientColors: [
                            Colors.orangeAccent,
                            Colors.deepOrange,
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BigDiamondOptionWidget(
                          title: "1135 Diamond",
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

                  // GRID VIEW DIAMOND
                  GridView.builder(
                    itemCount: diamondList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final item = diamondList[index];
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
                              content: Text("Pilih salah satu paket diamond terlebih dahulu"),
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
                              paketDiamond: diamondList[_selectedIndex!]['text']!,
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
