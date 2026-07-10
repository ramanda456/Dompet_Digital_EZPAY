import 'package:flutter/material.dart';

class SyaratKetentuanPage extends StatelessWidget {
  const SyaratKetentuanPage({super.key});

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

              // Header atas dengan logo EZ Pay
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
                      "Syarat dan\nketentuan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
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

              // Konten teks panjang (scrollable)
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
Syarat dan Ketentuan Penggunaan EZ Pay

Dengan menggunakan Aplikasi EZ Pay (“Aplikasi”), Anda dianggap telah membaca, memahami, dan menyetujui seluruh isi dari Syarat dan Ketentuan ini. Jika Anda tidak setuju, silakan hentikan penggunaan Aplikasi.

1. Syarat Pengguna
Pengguna Aplikasi EZ Pay harus:
• Memiliki perangkat yang mendukung penggunaan Aplikasi.  
• Memberikan informasi yang benar, lengkap, dan terbaru saat melakukan pendaftaran.  
• Bertanggung jawab atas kebenaran data yang diberikan.  
• Bersedia mematuhi seluruh kebijakan dan aturan yang berlaku di EZ Pay.  
• Tidak sedang dilarang menggunakan layanan keuangan digital.  

2. Ketentuan Pengguna
a. Akun dan Keamanan  
• Pengguna bertanggung jawab atas kerahasiaan akun dan kata sandi.  
• Segala aktivitas yang terjadi melalui akun menjadi tanggung jawab Pengguna.  
• Akun tidak boleh dipindah­tangankan kepada pihak lain.  

b. Penggunaan Layanan  
• Pengguna hanya boleh memakai Aplikasi untuk tujuan yang sah dan sesuai hukum.  
• Pengguna dilarang melakukan penipuan, peretasan, atau penyalahgunaan informasi.  
• Pengguna tidak diperbolehkan melakukan tindakan yang mengganggu, merusak, atau membebani sistem atau server Aplikasi.  

c. Etika dan Kepatuhan  
• Pengguna wajib menggunakan identitas yang valid.  
• Pengguna tidak boleh mengunggah atau menyebarkan konten ilegal, merugikan, menyesatkan, atau melanggar privasi.  
• Pengguna wajib mengikuti hukum yang berlaku di wilayahnya.  

3. Batasan Tanggung Jawab  
EZ Pay tidak bertanggung jawab atas kerugian langsung maupun tidak langsung yang timbul akibat penggunaan Aplikasi.  
Informasi dari pihak ketiga yang muncul dalam Aplikasi bukan menjadi tanggung jawab penuh EZ Pay.  

4. Perlindungan dan Penggunaan Data Pribadi  
Data pribadi Pengguna akan diproses sesuai Kebijakan Privasi yang berlaku.  
Data Pengguna dapat digunakan oleh EZ Pay untuk pengembangan layanan dan kebutuhan operasional yang sah.  

5. Ketentuan Lain  
EZ Pay berhak mengubah Syarat dan Ketentuan kapan saja. Perubahan akan diberitahukan melalui Aplikasi.  
Syarat dan Ketentuan ini tunduk pada hukum yang berlaku di wilayah yurisdiksi Pengguna.  

Untuk pertanyaan atau pengaduan, hubungi:  
• Email: ezpay@gmail.com  
• Telepon: 085234567890
                      ''',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.black87,
                      ),
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
