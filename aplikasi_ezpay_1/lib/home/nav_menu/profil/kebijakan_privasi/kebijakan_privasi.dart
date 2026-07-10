import 'package:flutter/material.dart';

class KebijakanPrivasiPage extends StatelessWidget {
  const KebijakanPrivasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50), // hijau atas
              Color(0xFF2196F3), // biru bawah
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

              // Header dengan logo dan judul
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
                      "Kebijakan dan\nprivasi",
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

              // Konten kebijakan (scrollable)
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
Kebijakan Privasi EZ Pay

Kebijakan Privasi ini menjelaskan bagaimana aplikasi EZ Pay (“Kami”) mengumpulkan, menggunakan, dan melindungi data pribadi Pengguna. Dengan menggunakan aplikasi kami, Anda dianggap menyetujui pengumpulan dan penggunaan informasi sebagaimana dijelaskan dalam kebijakan ini.

1. Informasi yang Dikumpulkan
a. Data Pribadi  
Saat membuat akun di EZ Pay, Anda mungkin diminta untuk memberikan informasi pribadi, seperti:  
• Nama lengkap  
• Alamat email  
• Nomor telepon  
• Informasi keuangan (contohnya rekening bank atau kartu kredit)

b. Data Teknis  
Kami juga mengumpulkan informasi teknis terkait penggunaan aplikasi, antara lain:  
• Alamat IP  
• Jenis perangkat dan sistem operasi  
• Riwayat aktivitas  
• Lokasi pengguna

2. Penggunaan Informasi  
Data yang kami kumpulkan digunakan untuk berbagai keperluan, seperti:  
• Menyediakan, mengelola, dan meningkatkan layanan dalam aplikasi.  
• Memproses transaksi finansial yang dilakukan Pengguna.  
• Mengirimkan informasi layanan, promosi, atau pemberitahuan perubahan kebijakan.  
• Menjaga keamanan akun dan data Pengguna.  
• Melakukan analisis untuk pengembangan fitur dan peningkatan kualitas layanan.

3. Pembagian Informasi  
Kami tidak akan menjual, menyewakan, atau menukar informasi pribadi Pengguna kepada pihak lain tanpa izin. Namun, data dapat dibagikan dalam kondisi berikut:  

a. Mitra atau Penyedia Layanan  
Kami dapat bekerja sama dengan pihak ketiga untuk mendukung operasional aplikasi, seperti layanan pembayaran atau analisis data.  

b. Kepatuhan terhadap Hukum  
Kami dapat mengungkapkan informasi apabila diwajibkan oleh hukum atau atas permintaan instansi berwenang.

4. Keamanan Data  
Kami berupaya melindungi informasi Pengguna dengan menerapkan langkah-langkah keamanan fisik, digital, dan administratif guna mencegah akses, penyalahgunaan, perubahan, atau pengungkapan yang tidak sah.

5. Hak Pengguna  
Pengguna memiliki hak atas data pribadi mereka, termasuk untuk:  
• Melihat, mengubah, atau menghapus informasi yang telah diberikan.  
• Menarik persetujuan atas penggunaan data, dengan pemahaman bahwa hal tersebut dapat memengaruhi akses terhadap layanan.

6. Penyimpanan Data  
Informasi pribadi akan disimpan selama masih diperlukan untuk penyediaan layanan atau selama diwajibkan oleh ketentuan hukum yang berlaku.

7. Perubahan Kebijakan  
Kebijakan Privasi ini dapat diperbarui sewaktu-waktu. Setiap perubahan akan diberitahukan melalui aplikasi atau sarana komunikasi lainnya.

8. Kontak  
Jika Anda memiliki pertanyaan atau keluhan terkait Kebijakan Privasi ini, silakan hubungi kami melalui:  
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
