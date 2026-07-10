import 'package:flutter/material.dart';
import '../transfer_ui.dart';
import 'transfer_e_wallet_dana/transfer_e_wallet_dana_page1.dart';

class TransferEWalletPage extends StatelessWidget {
  const TransferEWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> wallets = [
      {'logo': 'assets/image/icon_gopay.png', 'name': 'Gopay'},
      {'logo': 'assets/image/icon_shopeepay.png', 'name': 'Shopee Pay'},
      {'logo': 'assets/image/icon_isaku.png', 'name': 'i Saku'},
      {'logo': 'assets/image/icon_dana.png', 'name': 'DANA'},
      {'logo': 'assets/image/icon_linkaja.png', 'name': 'Link Aja'},
    ];

    return TransferUi.page(
      context,
      title: 'Transfer E-wallet',
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
        ...wallets.expand((wallet) {
          return [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (wallet['name'] == 'DANA') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TransferEWalletDanaPage1(),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                          wallet['logo'] as String,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          wallet['name'] as String,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right,
                          size: 22, color: Colors.grey.shade500),
                    ],
                  ),
                ),
              ),
            ),
            Divider(height: 1, thickness: 0.7, color: Colors.grey.shade300),
          ];
        }),
      ],
    );
  }
}
