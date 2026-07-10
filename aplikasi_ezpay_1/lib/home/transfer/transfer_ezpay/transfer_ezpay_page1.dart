import 'package:flutter/material.dart';
import '../transfer_ui.dart';
import 'transfer_ezpay_page2.dart';

class TransferEzPayPage1 extends StatefulWidget {
  const TransferEzPayPage1({super.key});

  @override
  State<TransferEzPayPage1> createState() => _TransferEzPayPage1State();
}

class _TransferEzPayPage1State extends State<TransferEzPayPage1> {
  final TextEditingController _akunController = TextEditingController();

  @override
  void dispose() {
    _akunController.dispose();
    super.dispose();
  }

  void _lanjutkan() {
    final akun = _akunController.text.trim();
    if (akun.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nomor akun EZ Pay terlebih dahulu'),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransferEzPayPage2(akun: akun),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TransferUi.ezPayScaffold(
      context,
      title: 'EZ Pay',
      bodyChildren: [
        TransferUi.ezPayCard(
          bodyChildren: [
            const Text(
              'Masukkan Nomor Akun EZ Pay',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _akunController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
              decoration:
                  TransferUi.inputDecoration(hint: 'Masukkan nomor akun'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _lanjutkan,
              style: TransferUi.primaryElevated(),
              child: const Text('Lanjutkan'),
            ),
          ],
        ),
      ],
    );
  }
}
