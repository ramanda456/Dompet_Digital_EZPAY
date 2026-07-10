import 'package:flutter/material.dart';
import '../../../home/home_screen.dart';

class BpjsPage5 extends StatelessWidget {
  const BpjsPage5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50),
      body: SafeArea(
        child: Column(
          children: [
            // Tombol Back
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Header Transaksi Berhasil
            Column(
              children: [
                Image.asset(
                  'assets/image/logo_ezpay.png',
                  width: 80,
                  height: 60,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Transaksi Berhasil',
                  style: TextStyle(
                    color: Color(0xFF3F51B5),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.check_circle, color: Colors.green, size: 22),
              ],
            ),
            const SizedBox(height: 20),

            // Kartu Rincian Transaksi
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF4CAF50),
                        Color(0xFF2196F3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Rincian Transaksi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Center(
                        child: Text(
                          'Bayar Tagihan BPJS',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Informasi BPJS
                      Row(
                        children: [
                          Image.asset(
                            'assets/image/icon_bpjs.png',
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Yamal',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Pembayaran BPJS | 11112345678',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Garis
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),

                      // Detail Transaksi
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ID Transaksi',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            'TRF2102190955',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Referensi',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            '-',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tanggal',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            '02 Oktober 2025 06.31',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Nominal Biaya',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                          Text('Rp 30.000',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 6),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Biaya Admin',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                          Text('Rp 2.000',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 6),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rp 32.000',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Tombol Selesai
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CA5EE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen())
                    );

                    },
                    child: const Text(
                      'Selesai',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
