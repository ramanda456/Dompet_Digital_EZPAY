import 'package:flutter/material.dart';
import '../../transfer_ui.dart';
import 'transfer_bank_bsi_page3.dart';

class TransferBankBSIPage2 extends StatelessWidget {
  final String rekening;

  const TransferBankBSIPage2({super.key, required this.rekening});

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
          readOnly: true,
          controller: TextEditingController(text: rekening),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFCFE8FF),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFF9EC9F0)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 22,
                child: Icon(Icons.person, size: 28, color: Colors.black54),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Roberto Carlos',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'BSI - $rekening',
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
                builder: (context) => TransferBankBSIPage3(
                  rekening: rekening,
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
