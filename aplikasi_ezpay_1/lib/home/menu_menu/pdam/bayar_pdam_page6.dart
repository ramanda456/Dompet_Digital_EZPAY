import 'package:flutter/material.dart';

class BayarPdamPage6 extends StatelessWidget {
  const BayarPdamPage6({super.key});

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
              Color(0xFF4CAF50),
              Color(0xFF2196F3),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Tombol Back
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Logo dan status
                Column(
                  children: [
                    Image.asset(
                      'assets/image/logo_ezpay.png',
                      width: 90,
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
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Container rincian
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.7),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Rincian Transaksi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Bayar PDAM',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Info PDAM
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/image/icon_pdam.png',
                            width: 45,
                            height: 45,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Neymar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'PDAM | 123456789',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Detail transaksi
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('ID Transaksi',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 14)),
                              Text('PD2102190955',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87)),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Referensi',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 14)),
                              Text('-',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87)),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Tanggal',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 14)),
                              Text('20 Agustus 2025 14.00',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87)),
                            ],
                          ),
                          Divider(
                            color: Colors.black26,
                            height: 30,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Nominal Biaya',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 14)),
                              Text('Rp 100.000',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87)),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Biaya Admin',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 14)),
                              Text('Rp 1.000',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87)),
                            ],
                          ),
                          Divider(
                            color: Colors.black26,
                            height: 25,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'Rp 101.000',
                                style: TextStyle(
                                  color: Color(0xFF3F51B5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Tombol selesai
                SizedBox(
                  width: 160,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF64B5F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text(
                      'Selesai',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
