import 'package:flutter/material.dart';
import '../../../home/home_screen.dart';
import '../../../../services/user_firestore_service.dart'; // formatSaldoIdr

class IsiPulsaPage6 extends StatelessWidget {
  final String nomorHp;
  final String nominal;
  final String harga;
  final String transactionCode;
  final String serialNumber;

  const IsiPulsaPage6({
    super.key,
    required this.nomorHp,
    required this.nominal,
    required this.harga,
    this.transactionCode = '-',
    this.serialNumber = '-',
  });

  @override
  Widget build(BuildContext context) {
    int hargaInt = int.tryParse(harga.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    int admin = 1500;
    int total = hargaInt + admin;

    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50),
      body: SafeArea(
        child: Column(
          children: [
            // ===== Header dan Tombol Back =====
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

            // ===== Logo dan Status =====
            Column(
              children: [
                Image.asset(
                  'assets/image/logo_ezpay.png',
                  width: 90,
                  height: 60,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Transaksi Berhasil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Icon(Icons.check_circle, color: Colors.white, size: 28),
              ],
            ),
            const SizedBox(height: 25),

            // ===== Kartu Rincian Transaksi =====
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        blurRadius: 8,
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
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          'Pembelian Pulsa $nominal',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ===== Info Pengguna =====
                      Row(
                        children: [
                          Image.asset(
                            'assets/image/phone_success.png',
                            width: 45,
                            height: 45,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pulsa $nominal',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Nomor: $nomorHp',
                                  style: const TextStyle(
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

                      Divider(color: Colors.white.withOpacity(0.4), thickness: 1),

                      const SizedBox(height: 16),

                      // ===== Detail Transaksi =====
                      _detailItem('ID Transaksi', transactionCode),
                      _detailItem('SN', serialNumber),
                      _detailItem('Tanggal', DateTime.now().toString().substring(0, 16)),
                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withOpacity(0.4), thickness: 1),
                      const SizedBox(height: 16),
                      _detailItem('Nominal Biaya', formatSaldoIdr(hargaInt)),
                      _detailItem('Biaya Admin', formatSaldoIdr(admin)),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formatSaldoIdr(total),
                            style: const TextStyle(
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

            // ===== Tombol Selesai =====
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
                      elevation: 3,
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
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

  // ===== Widget Reusable untuk Detail Item =====
  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
