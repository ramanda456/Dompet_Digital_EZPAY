import 'package:flutter/material.dart';
// ignore: unused_import
import '../pengaturan_profil.dart'; // untuk kembali nanti jika mau arahkan balik setelah page2
import 'ubah_nama_page2.dart'; // navigasi ke halaman verifikasi atau konfirmasi

class UbahNamaPage1 extends StatefulWidget {
  const UbahNamaPage1({super.key});

  @override
  State<UbahNamaPage1> createState() => _UbahNamaPage1State();
}

class _UbahNamaPage1State extends State<UbahNamaPage1> {
  final TextEditingController _namaController = TextEditingController();

  void _lanjutkan() {
    if (_namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silahkan isi nama terlebih dahulu")),
      );
      return;
    }

    // Navigasi ke halaman berikut (page2)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UbahNamaPage2(namaBaru: _namaController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          // ================== HEADER ==================
          Container(
            width: double.infinity,
            height: size.height * 0.25,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "EZ Pay",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Silahkan masukkan Nama yang ingin anda Ubah",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // ================== KONTEN ==================
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Isi nama anda dibawah ini :",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _namaController,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan nama baru anda',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _lanjutkan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2962FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Lanjutkan",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
