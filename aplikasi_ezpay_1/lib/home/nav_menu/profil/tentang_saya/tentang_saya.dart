import 'package:flutter/material.dart';

class TentangSayaPage extends StatelessWidget {
  const TentangSayaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50), // Hijau atas
              Color(0xFF2196F3), // Biru bawah
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Tombol kembali
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              // Header dengan judul dan logo EZ Pay
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Tentang\nsaya",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      'assets/image/logo_ezpay.png',
                      width: 90,
                      height: 70,
                    ),
                    const Text(
                      "EZ Pay",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3F51B5),
                      ),
                    ),
                  ],
                ),
              ),

              // Konten teks (scrollable)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(
                    child: const Text(
                      '''
EZ Pay adalah aplikasi dompet digital yang dirancang untuk membuat transaksi keuangan menjadi lebih praktis, cepat, dan aman.  
Dengan EZ Pay, pengguna dapat melakukan berbagai aktivitas keuangan hanya dalam satu aplikasi — mulai dari menyimpan saldo, membayar berbagai kebutuhan, hingga mengirim uang dengan mudah kapan saja dan di mana saja.

Kenapa EZ Pay?  
• Mudah digunakan  
• Transaksi lebih cepat  
• Aman dan terpercaya  

EZ Pay hadir untuk mendukung gaya hidup digital masyarakat modern yang ingin semua serba efisien dan fleksibel.  
Kami berkomitmen untuk terus menghadirkan fitur-fitur terbaik demi memberikan pengalaman transaksi yang lebih nyaman bagi semua pengguna.
                      ''',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
