import 'package:flutter/material.dart';

class TopUpEwalletShoppePayPage5 extends StatelessWidget {
  final String saldo = "Rp. 1.275.500,-";
  final String ewallet = "Shoppe pay";
  final String nomorHp = "081020304050";
  final String nama = "RONALDO";
  final String jumlahTopUp = "Rp 100.000";
  final String biayaAdmin = "Rp 1.000";
  final String total = "Rp 101.000";

  const TopUpEwalletShoppePayPage5({super.key});

  @override
  Widget build(BuildContext context) {
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
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  saldo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.black,
                  thickness: 1,
                  height: 20,
                  indent: 0,
                  endIndent: 0,
                ),

                const SizedBox(height: 16),

                // Detail transaksi
                _buildDetailRow("E-wallet", ewallet),
                const SizedBox(height: 6),
                _buildDetailRow("No.Handphone", nomorHp, boldValue: true),
                const SizedBox(height: 6),
                _buildDetailRow("Nama", nama, boldValue: true),
                const SizedBox(height: 6),
                _buildDetailRow("Jumlah Top Up", jumlahTopUp, boldValue: true),
                const SizedBox(height: 6),
                _buildDetailRow("Biaya Admin", biayaAdmin, boldValue: true),
                const SizedBox(height: 10),
                _buildDetailRow("Total", total, boldLabel: true, boldValue: true),

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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Transaksi dikonfirmasi')),
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
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: boldValue ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
