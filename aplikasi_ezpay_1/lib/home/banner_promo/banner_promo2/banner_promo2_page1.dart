import 'package:flutter/material.dart';

class BannerPromo2Page1 extends StatelessWidget {
  const BannerPromo2Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header gradasi hijau ke biru
          Container(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 20),
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3BBE78), Color(0xFF0072BB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 4),
                const Text(
                  "BEBAS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),

          // Konten utama
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner promo
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/image/banner4.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Judul promo
                  const Text(
                    "(NEW USER) CASHBACK GACOR BAYAR TAGIHAN BPJS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "periode 1 september - 31 oktober 2025",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Syarat & ketentuan
                  const Text(
                    "Syarat & ketentuan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.black12,
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "1. Pastikan akun kamu sudah terdaftar dan aktif di aplikasi EZ Pay untuk bisa menerima cashback.\n\n"
                    "2. Dapatkan CASHBACK 10.000 Poin Cash untuk setiap transaksi pembayaran tagihan BPJS minimal Rp100.000 menggunakan aplikasi EZ Pay.\n\n"
                    "3. Sebelum menyelesaikan pembayaran, pilih dan gunakan kupon promo yang tersedia di aplikasi EZ Pay untuk mendapatkan cashback.\n\n"
                    "4. Promo berlaku maksimal 2x per akun/device per bulan selama periode promo berlangsung.\n\n"
                    "5. Cashback akan diberikan dalam bentuk Poin Cash dan akan masuk ke akun EZ Pay pengguna maksimal dalam waktu 3x24 jam setelah transaksi berhasil.\n\n"
                    "6. Periode promo: 1 September – 31 Oktober 2025.",
                    style: TextStyle(
                      height: 1.5,
                      color: Colors.black87,
                      fontSize: 14,
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
