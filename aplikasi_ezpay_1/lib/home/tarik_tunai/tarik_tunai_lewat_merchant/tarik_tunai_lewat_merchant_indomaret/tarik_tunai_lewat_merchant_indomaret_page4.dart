import 'package:flutter/material.dart';
import '../../../home_screen.dart';
import '../../../../services/user_firestore_service.dart'; // formatSaldoIdr

class TarikTunaiLewatMerchantIndomaretPage4 extends StatelessWidget {
  final double amount;
  final String withdrawalCode;
  final String transactionCode;
  final double adminFee;

  const TarikTunaiLewatMerchantIndomaretPage4({
    super.key,
    required this.amount,
    required this.withdrawalCode,
    required this.transactionCode,
    required this.adminFee,
  });

  @override
  Widget build(BuildContext context) {
    final double total = amount + adminFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      ),
                    ),
                    const Text(
                      "Indomaret",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // Kartu Merchant
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/image/icon_indomaret.png', height: 30),
                      const SizedBox(width: 12),
                      const Text(
                        "INDOMARET",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Kode Token
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Logo EZPay
                      Image.asset('assets/image/money_icon.png', height: 35),
                      const SizedBox(height: 10),

                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDDEFFF),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                "Kode Siap Digunakan!",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              withdrawalCode,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Berlaku hingga 1x24 jam setelah kode ditampilkan",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 18),

                            _buildDetailRow("ID Transaksi", transactionCode),
                            _buildDetailRow("Nominal Tarik Tunai", formatSaldoIdr(amount.toInt())),
                            _buildDetailRow("Tarik Tunai Melalui", "INDOMARET"),
                            _buildDetailRow("Biaya Admin", formatSaldoIdr(adminFee.toInt())),
                            const Divider(),
                            _buildDetailRow("Total Terpotong", formatSaldoIdr(total.toInt()), bold: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Cara Pakai Barcode
                const Text(
                  "Cara Pakai Barcode ini",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                  ),
                ),
                const Divider(thickness: 1, color: Colors.black),
                const SizedBox(height: 5),
                const Text(
                  "1. Tunjukkan Kode Token ke kasir sebelum kadaluarsa\n"
                  "2. Beri tahu kasir nominal tarik tunai, kode token, dan no. HP yang terdaftar di akun EZ Pay\n"
                  "3. Setelah transaksi berhasil, kasir akan memberikan uang tunai dan saldo EZ Pay-mu akan terpotong",
                  style: TextStyle(fontSize: 13, height: 1.6, fontFamily: 'Poppins'),
                ),

                const SizedBox(height: 40),

                // Tombol kembali
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "KEMBALI KE BERANDA",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
