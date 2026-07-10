import 'package:flutter/material.dart';
import '../transfer_ui.dart';
import 'transfer_bank_bsi/transfer_bank_bsi_page1.dart';

class TransferBankPage extends StatelessWidget {
  const TransferBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TransferUi.page(
      context,
      title: 'transfer bank',
      children: [
        const Text(
          'Pilih bank tujuan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _bankItem(
          image: 'assets/image/icon_mandiri.png',
          name: 'Bank Mandiri',
          onTap: () {},
        ),
        _divider(),
        _bankItem(
          image: 'assets/image/icon_bri.png',
          name: 'Bank BRI',
          onTap: () {},
        ),
        _divider(),
        _bankItem(
          image: 'assets/image/icon_bni.png',
          name: 'Bank BNI',
          onTap: () {},
        ),
        _divider(),
        _bankItem(
          image: 'assets/image/icon_bank_bsi.png',
          name: 'Bank BSI',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TransferBankBsiPage1(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Divider(height: 1, thickness: 0.7, color: Colors.grey.shade300),
    );
  }

  Widget _bankItem({
    required String image,
    required String name,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              Image.asset(
                image,
                width: 70,
                height: 30,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, size: 22, color: Colors.grey.shade500),
            ],
          ),
        ),
      ),
    );
  }
}
