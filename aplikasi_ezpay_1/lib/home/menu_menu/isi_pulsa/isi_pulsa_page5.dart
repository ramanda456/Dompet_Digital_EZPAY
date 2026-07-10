import 'package:flutter/material.dart';
import '../../menu_menu/isi_pulsa/isi_pulsa_page6.dart';

class IsiPulsaPage5 extends StatelessWidget {
  final String nomorHp;
  final String nominal;
  final String harga;
  final String transactionCode;
  final String serialNumber;

  const IsiPulsaPage5({
    super.key,
    required this.nomorHp,
    required this.nominal,
    required this.harga,
    this.transactionCode = '-',
    this.serialNumber = '-',
  });

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
              Color(0xFF4CAF50),
              Color(0xFF2196F3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar Telepon
              Image.asset(
                'assets/image/phone_success.png',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),

              // Judul
              const Text(
                'Transaksi Berhasil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Keterangan
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Hore! Transaksi Anda telah selesai.\nPeriksa detail transaksi terakhir Anda di riwayat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // Tombol "Lihat Detail"
              SizedBox(
                width: 220,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Color(0xFF3F51B5)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => IsiPulsaPage6(
                          nomorHp: nomorHp,
                          nominal: nominal,
                          harga: harga,
                          transactionCode: transactionCode,
                          serialNumber: serialNumber,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Lihat Detail',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F51B5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tombol "Kembali ke Beranda"
              SizedBox(
                width: 220,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Color(0xFF3F51B5)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(
                      fontSize: 15,
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
