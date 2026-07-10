import 'package:flutter/material.dart';
import '../../menu_menu/paket_data/paket_data_page6.dart';

class PaketDataPage5 extends StatelessWidget {
  const PaketDataPage5({super.key});

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
              colors: [Color(0xFF4CAF50), Color(0xFF2196F3)]),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/image/phone_success.png', width: 180),
              const SizedBox(height: 24),
              const Text('Transaksi Berhasil',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87)),
              const SizedBox(height: 16),
              const Text('Transaksi selesai. Cek riwayat untuk detail.'),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF3F51B5))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PaketDataPage6()),
                  );
                },
                child: const Text('Lihat Detail',
                    style: TextStyle(color: Color(0xFF3F51B5))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
