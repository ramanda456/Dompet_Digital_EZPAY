import 'package:flutter/material.dart';
import '../../menu_menu/paket_data/paket_data_page4.dart';

class PaketDataPage3 extends StatelessWidget {
  final String kuota;
  final String harga;
  const PaketDataPage3({super.key, required this.kuota, required this.harga});

  @override
  Widget build(BuildContext context) {
    int hargaInt = int.tryParse(harga.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    int admin = 1000;
    int total = hargaInt + admin;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Saldo Anda Saat Ini',
                    style: TextStyle(color: Colors.black87, fontSize: 14)),
                const SizedBox(height: 8),
                const Text('Rp 1.275.500,-',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                const Text('Ringkasan Pembayaran',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 12),
                Text('Paket Internet $kuota',
                    style:
                        const TextStyle(color: Colors.black87, fontSize: 14)),
                const SizedBox(height: 4),
                Text('Harga: $harga',
                    style:
                        const TextStyle(color: Colors.black87, fontSize: 14)),
                const SizedBox(height: 4),
                const Text('Admin: Rp1.000',
                    style: TextStyle(color: Colors.black87, fontSize: 14)),
                const Divider(height: 24, color: Colors.black26),
                Text('Total: Rp$total',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F51B5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaketDataPage4(),
                        ),
                      );
                    },
                    child: const Text('Bayar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
