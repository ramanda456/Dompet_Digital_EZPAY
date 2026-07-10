import 'package:flutter/material.dart';
import '../../transfer_ui.dart';
import 'transfer_bank_bsi_page2.dart';

class TransferBankBsiPage1 extends StatefulWidget {
  const TransferBankBsiPage1({super.key});

  @override
  State<TransferBankBsiPage1> createState() => _TransferBankBsiPage1State();
}

class _TransferBankBsiPage1State extends State<TransferBankBsiPage1> {
  final _rekeningController = TextEditingController();

  @override
  void dispose() {
    _rekeningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TransferUi.page(
      context,
      title: 'Bank BSI',
      headerOnGradient: TransferUi.gradientChip(
        child: Row(
          children: [
            Image.asset(
              'assets/image/icon_bank_bsi.png',
              width: 64,
              height: 28,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Bank Syariah Indonesia (BSI)',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
      children: [
        const Text(
          'Masukkan nomor rekening tujuan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _rekeningController,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
          decoration: TransferUi.inputDecoration(hint: 'Masukkan No. Rekening'),
        ),
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: () {
            final rek = _rekeningController.text.trim();
            if (rek.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Masukkan nomor rekening tujuan')),
              );
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransferBankBSIPage2(rekening: rek),
              ),
            );
          },
          style: TransferUi.primaryElevated(),
          child: const Text('Lanjutkan'),
        ),
      ],
    );
  }
}
