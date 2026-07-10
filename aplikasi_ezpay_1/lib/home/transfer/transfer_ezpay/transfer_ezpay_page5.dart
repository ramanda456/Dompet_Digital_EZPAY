import 'package:flutter/material.dart';
import '../transfer_ui.dart';
import '../../home_screen.dart';
import '../../../../services/user_firestore_service.dart'; // formatSaldoIdr

class TransferEzPayPage5 extends StatelessWidget {
  final String recipientName;
  final String recipientPhone;
  final double amount;
  final String transactionCode;
  final String date;
  final double adminFee;

  const TransferEzPayPage5({
    super.key,
    required this.recipientName,
    required this.recipientPhone,
    required this.amount,
    required this.transactionCode,
    required this.date,
    this.adminFee = 0,
  });

  @override
  Widget build(BuildContext context) {
    final total = amount + adminFee;

    return TransferUi.successPage(
      context,
      cardChildren: [
        TransferUi.successHeaderRow(),
        TransferUi.successDetailTitleBand(),
        const SizedBox(height: 14),
        const Text(
          'Transfer EZ Pay',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFCFE8FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF9EC9F0)),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/image/icon_ezpay.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipientName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'EZ Pay | $recipientPhone',
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
        ),
        const SizedBox(height: 16),
        _row('ID Transaksi', transactionCode),
        _row('Referensi', '-'),
        _row('Tanggal', date.length >= 16 ? date.substring(0, 16) : date),
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
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
