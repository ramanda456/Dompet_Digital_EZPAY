import 'package:flutter/material.dart';
import '../../transfer_ui.dart';
import '../../../home_screen.dart';
import '../../../../services/user_firestore_service.dart'; // formatSaldoIdr

class TransferEWalletDanaPage5 extends StatelessWidget {
  final String nomorHp;
  final String nama;
  final double amount;
  final String transactionCode;
  final String date;
  final double adminFee;

  const TransferEWalletDanaPage5({
    super.key,
    required this.nomorHp,
    required this.nama,
    required this.amount,
    required this.transactionCode,
    required this.date,
    required this.adminFee,
  });

  @override
  Widget build(BuildContext context) {
    final double total = amount + adminFee;
    return TransferUi.successPage(
      context,
      cardChildren: [
        TransferUi.successHeaderRow(),
        TransferUi.successDetailTitleBand(),
        const SizedBox(height: 12),
        const Text(
          'Transfer E-wallet',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Image.asset(
                'assets/image/icon_dana.png',
                width: 34,
                height: 34,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Dana | $nomorHp',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 24),
        _detail('ID Transaksi', transactionCode),
        _detail('Referensi', '-'),
        _detail('Tanggal', date.length >= 19 ? date.substring(0, 19) : date),
        const Divider(height: 22),
        _detail('Nominal Transfer', formatSaldoIdr(amount.toInt())),
        _detail('Biaya Admin', formatSaldoIdr(adminFee.toInt())),
        _detail('Total', formatSaldoIdr(total.toInt()), bold: true),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          },
          style: TransferUi.primaryElevated(),
          child: const Text('Selesai'),
        ),
      ],
    );
  }

  Widget _detail(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
