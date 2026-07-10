import 'package:flutter/material.dart';
import '../../transfer_ui.dart';
import 'transfer_e_wallet_dana_page2.dart';

class TransferEWalletDanaPage1 extends StatefulWidget {
  const TransferEWalletDanaPage1({super.key});

  @override
  State<TransferEWalletDanaPage1> createState() =>
      _TransferEWalletDanaPage1State();
}

class _TransferEWalletDanaPage1State extends State<TransferEWalletDanaPage1> {
  final _accountController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TransferUi.page(
      context,
      title: 'Dana',
      headerOnGradient: TransferUi.gradientChip(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/icon_dana.png',
              width: 44,
              height: 44,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Transfer ke DANA',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
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
          'Masukkan Nomor Akun Dana',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _accountController,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
          decoration: TransferUi.inputDecoration(hint: 'Contoh: 081234567890'),
        ),
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: () {
            final noHp = _accountController.text.trim();
            if (noHp.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Masukkan nomor akun Dana tujuan')),
              );
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransferEWalletDanaPage2(nomorHp: noHp),
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
