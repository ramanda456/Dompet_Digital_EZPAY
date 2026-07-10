import 'package:flutter/material.dart';

// Hanya dua import sesuai permintaan
import '../../home/isi_saldo/isi_saldo_lewat_bank/isi_saldo_lewat_bank_bri/isi_saldo_lewat_bank_bri_page1.dart';
import '../../home/isi_saldo/isi_saldo_uang_tunai/isi_saldo_uang_tunai_indomaret/isi_saldo_uang_tunai_indomaret_page1.dart';

class IsiSaldoPage extends StatelessWidget {
  const IsiSaldoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- Latar belakang gradient ---
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // --- Panel putih di bawah gradient ---
          Positioned(
            top: h * 0.38,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
            ),
          ),

          // --- Konten scrollable ---
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),

                    // Header
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Isi Saldo",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),

                    // ---------- Kartu 1: Pakai Uang Tunai ----------
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: _cardBox(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Pakai uang tunai",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Di minimarket, warung atau agen terdekat",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Indomaret (aktif navigasi)
                          _menuItem(
                            context,
                            'assets/image/icon_indomaret.png',
                            'INDOMARET',
                            const IsiSaldoUangTunaiIndomaretPage1(),
                          ),

                          // Sisanya dummy (tidak ada navigasi)
                          _menuItem(context, 'assets/image/icon_alfamart.png', 'ALFAMART', null),
                          _menuItem(context, 'assets/image/icon_alfamidi.png', 'ALFAMIDI', null),
                          _menuItem(context, 'assets/image/icon_brilink.png', 'Agen BRILink', null),
                        ],
                      ),
                    ),

                    // ---------- Kartu 2: Lewat Bank ----------
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: _cardBox(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Lewat Bank",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Dari ATM, m-banking, dan lain-lain",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10),

                          _menuItem(context, 'assets/image/icon_mandiri.png', 'Bank Mandiri', null),

                          // Bank BRI (aktif navigasi)
                          _menuItem(
                            context,
                            'assets/image/icon_bri.png',
                            'Bank BRI',
                            const IsiSaldoLewatBankBriPage1(),
                          ),

                          _menuItem(context, 'assets/image/icon_bni.png', 'Bank BNI', null),
                          _menuItem(context, 'assets/image/icon_bsi.png', 'Bank BSI', null),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== Helper UI =====
  BoxDecoration _cardBox() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  Widget _menuItem(
    BuildContext context,
    String logoPath,
    String title,
    Widget? nextPage,
  ) {
    return GestureDetector(
      onTap: () {
        if (nextPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(logoPath, width: 50, height: 28, fit: BoxFit.contain),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
