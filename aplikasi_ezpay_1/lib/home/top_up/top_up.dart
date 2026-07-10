import 'package:flutter/material.dart';

import 'top_up_e_wallet/top_up_e_wallet_shoppepay/top_up_e_wallet_shoppepay_page1.dart';

class TopUpPage extends StatelessWidget {
  const TopUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final List<Map<String, String>> eWalletList = <Map<String, String>>[
      {'nama': 'Gopay', 'logo': 'assets/image/icon_gopay.png'},
      {'nama': 'ShopeePay', 'logo': 'assets/image/icon_shopeepay.png'},
      {'nama': 'iSaku', 'logo': 'assets/image/icon_isaku.png'},
      {'nama': 'DANA', 'logo': 'assets/image/icon_dana.png'},
      {'nama': 'LinkAja', 'logo': 'assets/image/icon_linkaja.png'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xFF4CAF50), Color(0xFF2196F3)],
              ),
            ),
          ),
          Positioned(
            top: h * 0.28,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 14),
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Top Up E-wallet',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 44),
                  const Text(
                    'Pilih E-wallet tujuan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: eWalletList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        final Map<String, String> item = eWalletList[index];
                        final String selectedName = item['nama'] ?? '';
                        final String logo = item['logo'] ?? '';

                        return GestureDetector(
                          onTap: () {
                            if (selectedName == 'ShopeePay') {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      const TopUpEwalletShoppePayPage1(),
                                ),
                              );
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Top up $selectedName akan segera hadir',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.07),
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  logo,
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    selectedName,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.black54,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
