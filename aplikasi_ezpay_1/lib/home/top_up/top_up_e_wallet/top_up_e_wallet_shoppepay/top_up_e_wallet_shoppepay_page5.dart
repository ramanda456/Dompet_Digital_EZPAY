import 'package:flutter/material.dart';
import '../../../../services/user_firestore_service.dart'; // formatSaldoIdr
import 'top_up_e_wallet_shoppepay_page6.dart';

class TopUpEwalletShoppePayPage5 extends StatelessWidget {
  final String penerimaNama;
  final String penerimaNomor;
  final String saldoUserNama;
  final String saldoUserNomor;
  final int saldoUserJumlahVal;
  final double amount;

  const TopUpEwalletShoppePayPage5({
    super.key,
    required this.penerimaNama,
    required this.penerimaNomor,
    required this.saldoUserNama,
    required this.saldoUserNomor,
    required this.saldoUserJumlahVal,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final double adminFee = 1000;
    final double total = amount + adminFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Saldo Header
                const Text(
                  "Saldo Anda saat ini",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formatSaldoIdr(saldoUserJumlahVal),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.black,
                  thickness: 1,
                  height: 20,
                ),

                const SizedBox(height: 16),

                // Detail transaksi
                _buildDetailRow("E-wallet", "ShopeePay"),
                const SizedBox(height: 6),
                _buildDetailRow("No. Handphone", penerimaNomor, boldValue: true),
                const SizedBox(height: 6),
                _buildDetailRow("Nama", penerimaNama, boldValue: true),
                const SizedBox(height: 6),
                _buildDetailRow("Jumlah Top Up", formatSaldoIdr(amount.toInt()), boldValue: true),
                const SizedBox(height: 6),
                _buildDetailRow("Biaya Admin", formatSaldoIdr(adminFee.toInt()), boldValue: true),
                const SizedBox(height: 10),
                _buildDetailRow("Total", formatSaldoIdr(total.toInt()), boldLabel: true, boldValue: true),

                const SizedBox(height: 30),

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopUpEwalletShoppePayPage6(
                            penerimaNama: penerimaNama,
                            penerimaNomor: penerimaNomor,
                            amount: amount,
                            adminFee: adminFee,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'KONFIRMASI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool boldLabel = false, bool boldValue = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: boldLabel ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: boldValue ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
