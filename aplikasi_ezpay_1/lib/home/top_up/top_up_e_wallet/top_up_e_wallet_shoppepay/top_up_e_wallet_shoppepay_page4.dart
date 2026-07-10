import 'package:flutter/material.dart';

class TopUpEwalletShoppePayPage4 extends StatefulWidget {
  const TopUpEwalletShoppePayPage4({super.key});

  @override
  State<TopUpEwalletShoppePayPage4> createState() =>
      _TopUpEwalletShoppePayPage4State();
}

class _TopUpEwalletShoppePayPage4State
    extends State<TopUpEwalletShoppePayPage4> {
  final TextEditingController nominalController = TextEditingController();
  String? selectedNominal;

  final List<String> nominalList = [
    '20.000',
    '30.000',
    '50.000',
    '100.000',
    '150.000',
    '200.000',
    '250.000',
    '300.000',
    '350.000',
    '400.000',
    '500.000',
    '1.000.000',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50), // Hijau
              Color(0xFF2196F3), // Biru
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child:
                          const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Shoppee Pay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // KONTEN UTAMA
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LOGO SHOPPE PAY
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/image/icon_shopeepay.png', // pastikan file ini ada
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Shoppee Pay',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Input Nominal
                      const Text(
                        'Masukkan Nominal',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      TextField(
                        controller: nominalController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Rp 0',
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black87, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Info minimal dan admin
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD3E8FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Minimal Top Up Rp 20.000\nBiaya Admin : Rp 1.000',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Label Pilih Nominal
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CA5EE),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Pilih Nominal',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Grid Nominal
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD3E8FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: GridView.builder(
                            itemCount: nominalList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 2.2,
                            ),
                            itemBuilder: (context, index) {
                              final nominal = nominalList[index];
                              final isSelected = selectedNominal == nominal;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedNominal = nominal;
                                    nominalController.text = 'Rp $nominal';
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF4CA5EE)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF4CA5EE)
                                          : Colors.transparent,
                                    ),
                                  ),
                                  child: Text(
                                    nominal,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Tombol Konfirmasi
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CA5EE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            if (nominalController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Silakan pilih atau masukkan nominal terlebih dahulu!'),
                                ),
                              );
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Nominal dikonfirmasi: ${nominalController.text}')),
                            );
                          },
                          child: const Text(
                            'KONFIRMASI',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
