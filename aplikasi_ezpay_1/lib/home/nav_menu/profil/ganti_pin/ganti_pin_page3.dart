import 'package:flutter/material.dart';

class GantiPinPage3 extends StatelessWidget {
  const GantiPinPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar kunci
              Image.asset(
                'assets/image/phone_success.png',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),

              // Teks Judul
              const Text(
                "PIN Berhasil Diubah",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              // Teks Subjudul
              const Text(
                "Selamat Sandi anda telah\nberhasil diubah",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Tombol Lanjutkan
              SizedBox(
                width: 200,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Color(0xFF3F51B5), width: 1.5),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
                    // TODO: Arahkan ke halaman beranda (misalnya HOME_SCREEN)
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    "Lanjutkan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F51B5),
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
