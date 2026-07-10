import 'package:flutter/material.dart';
import 'isi_pulsa_page3.dart';

class IsiPulsaPage2 extends StatelessWidget {
  final String nomorHp;

  const IsiPulsaPage2({super.key, required this.nomorHp});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> nominalPulsa = [
      {'nominal': '2 rb', 'harga': 'Rp1.500'},
      {'nominal': '5 rb', 'harga': 'Rp3.500'},
      {'nominal': '10 rb', 'harga': 'Rp8.500'},
      {'nominal': '20 rb', 'harga': 'Rp19.500'},
      {'nominal': '35 rb', 'harga': 'Rp30.500'},
      {'nominal': '15 rb', 'harga': 'Rp14.500'},
      {'nominal': '40 rb', 'harga': 'Rp38.500'},
      {'nominal': '45 rb', 'harga': 'Rp41.500'},
      {'nominal': '50 rb', 'harga': 'Rp38.500'},
      {'nominal': '100 rb', 'harga': 'Rp88.500'},
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF2196F3),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 24),

                Center(
                  child: Column(
                    children: const [
                      Text(
                        'Pilih Nominal pulsa',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Masukkan Nomor Telepon Anda',
                        style:
                            TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                const Text(
                  'Tujuan',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),

                // Nomor HP dari halaman sebelumnya
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Text(
                            nomorHp,
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 16),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Image.asset(
                          'assets/image/telkomsel_logo.png',
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Silahkan ketik Nomormu',
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 30),

                // Grid Nominal
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 2.3,
                  ),
                  itemCount: nominalPulsa.length,
                  itemBuilder: (context, index) {
                    final item = nominalPulsa[index];
                    return GestureDetector(
                      onTap: () {
                        // 🔹 Navigasi ke halaman 3 dengan data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IsiPulsaPage3(
                              nomorHp: nomorHp,
                              nominal: item['nominal']!,
                              harga: item['harga']!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item['nominal']!,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['harga']!,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2196F3)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
