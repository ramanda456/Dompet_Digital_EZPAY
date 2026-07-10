import 'package:flutter/material.dart';
import '../../transfer_ui.dart';
import 'transfer_e_wallet_dana_page4.dart';

class TransferEWalletDanaPage3 extends StatefulWidget {
  final String nomorHp;
  final String nama;

  const TransferEWalletDanaPage3({
    super.key,
    required this.nomorHp,
    required this.nama,
  });

  @override
  State<TransferEWalletDanaPage3> createState() =>
      _TransferEWalletDanaPage3State();
}

class _TransferEWalletDanaPage3State extends State<TransferEWalletDanaPage3> {
  final _nominalController = TextEditingController();

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }

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
                  Text(
                    widget.nama,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'DANA - ${widget.nomorHp}',
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
            color: const Color(0xFFD4EAFF),
            borderRadius: BorderRadius.circular(16),
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
                builder: (context) => TransferEWalletDanaPage4(
                  nomorHp: widget.nomorHp,
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
