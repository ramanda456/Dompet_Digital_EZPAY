import 'package:flutter/material.dart';
import '../../transfer_ui.dart';
import 'transfer_bank_bsi_page4.dart';

class TransferBankBSIPage3 extends StatefulWidget {
  final String rekening;
  final String nama;

  const TransferBankBSIPage3({
    super.key,
    required this.rekening,
    required this.nama,
  });

  @override
  State<TransferBankBSIPage3> createState() => _TransferBankBSIPage3State();
}

class _TransferBankBSIPage3State extends State<TransferBankBSIPage3> {
  final TextEditingController _nominalController = TextEditingController();

  @override
  void dispose() {
    _nominalController.dispose();
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
          'Rekening tujuan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
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
                  Text(
                    widget.nama,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'BSI - ${widget.rekening}',
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
        const SizedBox(height: 22),
        const Text(
          'Masukkan Nominal',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _nominalController,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontFamily: 'Poppins'),
          decoration: TransferUi.inputDecoration(hint: 'Rp 0'),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFCFE8FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF9EC9F0)),
          ),
          child: const Text(
            'Minimal Transfer Rp 20.000\nBiaya Admin : Rp 1.000',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: () {
            final nomText = _nominalController.text.trim();
            final nominal = double.tryParse(nomText) ?? 0;
            if (nominal < 20000) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Minimal transfer Rp 20.000')),
              );
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransferBankBSIPage4(
                  rekening: widget.rekening,
                  nama: widget.nama,
                  amount: nominal,
                ),
              ),
            );
          },
          style: TransferUi.primaryElevated(),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Transfer'),
              SizedBox(width: 8),
              Icon(Icons.play_arrow_rounded, size: 22, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }
}
