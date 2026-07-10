import 'package:flutter/material.dart';
import '../../transfer_ui.dart';
import '../../../home_screen.dart';
import '../../../../services/user_firestore_service.dart'; // formatSaldoIdr

class TransferBankBSIPage5 extends StatelessWidget {
  final String rekening;
  final String nama;
  final double amount;
  final String transactionCode;
  final String date;
  final double adminFee;

  const TransferBankBSIPage5({
    super.key,
    required this.rekening,
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
        const SizedBox(height: 14),
        const Text(
          'Transfer Bank',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Image.asset('assets/image/icon_bsi.png', width: 38),
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
                    'Bank Syariah Indonesia | $rekening',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 28),
        _row('ID Transaksi', transactionCode),
        _row('Referensi', '-'),
        _row('Tanggal', date.length >= 19 ? date.substring(0, 19) : date),
        const Divider(height: 22),
        _row('Nominal Transfer', formatSaldoIdr(amount.toInt())),
        _row('Biaya Admin', formatSaldoIdr(adminFee.toInt())),
        _row('Total', formatSaldoIdr(total.toInt()), bold: true),
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

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
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
              fontSize: 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
