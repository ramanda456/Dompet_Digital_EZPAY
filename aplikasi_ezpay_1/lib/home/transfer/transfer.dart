import 'package:flutter/material.dart';
import 'transfer_bank/transfer_bank.dart';
import 'transfer_e_wallet/transfer_e_wallet.dart';
import 'transfer_ezpay/transfer_ezpay_page1.dart';
import 'transfer_ui.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TransferUi.page(
      context,
      title: 'Transfer',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _transferOption(
              context,
              icon: 'assets/image/icon_bank.png',
              label: 'Bank',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransferBankPage(),
                  ),
                );
              },
            ),
            _transferOption(
              context,
              icon: 'assets/image/icon_ewallet.png',
              label: 'e-wallet',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransferEWalletPage(),
                  ),
                );
              },
            ),
            _transferOption(
              context,
              icon: 'assets/image/icon_ezpay_transfer.png',
              label: 'EZ Pay',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransferEzPayPage1(),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 26),
        const Text(
          'Riwayat',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        _historyItem('Roberto Carlos', 'BSI - 7272399830'),
        _historyItem('Roberto Carlos', 'Dana - 081234567890'),
        _historyItem('Roberto Carlos', 'EZ Pay - 081234567890'),
        _historyItem('Ronaldo', 'Shoppe Pay - 081020304050'),
      ],
    );
  }

  Widget _transferOption(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 82,
            height: 74,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: TransferUi.borderSoft),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(icon, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyItem(String name, String detail) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFCFE8FF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF9EC9F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 22,
            child: Icon(Icons.person, size: 28, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  detail,
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
    );
  }
}
