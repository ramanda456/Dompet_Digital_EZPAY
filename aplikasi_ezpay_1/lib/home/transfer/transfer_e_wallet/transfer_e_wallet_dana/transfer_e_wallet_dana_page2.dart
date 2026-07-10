import 'package:flutter/material.dart';
import '../../transfer_ui.dart';
import 'transfer_e_wallet_dana_page3.dart';

class TransferEWalletDanaPage2 extends StatelessWidget {
  final String nomorHp;

  const TransferEWalletDanaPage2({super.key, required this.nomorHp});

  @override
  Widget build(BuildContext context) {
    return TransferUi.page(
      context,
      title: 'Dana',
      headerOnGradient: TransferUi.gradientChip(
        child: Row(
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
          readOnly: true,
          controller: TextEditingController(text: nomorHp),
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
          decoration: TransferUi.inputDecoration(),
        ),
        const SizedBox(height: 22),
        const Text(
          'Konfirmasi Penerima',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFCFE8FF),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFF9EC9F0)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.black54, size: 28),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Roberto Carlos',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Dana - $nomorHp',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransferEWalletDanaPage3(
                  nomorHp: nomorHp,
                  nama: 'Roberto Carlos',
                ),
              ),
            );
          },
          style: TransferUi.primaryElevated(),
          child: const Text('Konfirmasi'),
        ),
      ],
    );
  }
}
