import 'package:flutter/material.dart';
import '../../../../services/user_firestore_service.dart'; // formatSaldoIdr

class TopUpEwalletShoppePayPage7 extends StatelessWidget {
  final String penerimaNama;
  final String penerimaNomor;
  final double amount;
  final double adminFee;
  final String transactionCode;
  final String date;

  const TopUpEwalletShoppePayPage7({
    super.key,
    required this.penerimaNama,
    required this.penerimaNomor,
    required this.amount,
    required this.adminFee,
    required this.transactionCode,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final double total = amount + adminFee;

    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50),
      body: SafeArea(
        child: Column(
          children: [
            // Spacer atas
            const SizedBox(height: 30),

            // Logo EZPay dan Status
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
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(Icons.check_circle, color: Colors.green, size: 24),
              ],
            ),
            const SizedBox(height: 20),

            // Kartu rincian transaksi
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
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Center(
                        child: Text(
                          'Top Up E-wallet',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Informasi penerima
                      Row(
                        children: [
                          Image.asset(
                            'assets/image/icon_shopeepay.png',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  penerimaNama,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  'ShopeePay | $penerimaNomor',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Garis pemisah
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),

                      // Detail transaksi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ID Transaksi',
                            style: TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'Poppins'),
                          ),
                          Text(
                            transactionCode,
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Referensi',
                            style: TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'Poppins'),
                          ),
                          Text(
                            '-',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tanggal',
                            style: TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'Poppins'),
                          ),
                          Text(
                            date.length >= 16 ? date.substring(0, 16) : date,
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins'),
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nominal Top Up',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins'),
                          ),
                          Text(
                            formatSaldoIdr(amount.toInt()),
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Biaya Admin',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins'),
                          ),
                          Text(
                            formatSaldoIdr(adminFee.toInt()),
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
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
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            formatSaldoIdr(total.toInt()),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
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
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text(
                      'Selesai',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Poppins',
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
