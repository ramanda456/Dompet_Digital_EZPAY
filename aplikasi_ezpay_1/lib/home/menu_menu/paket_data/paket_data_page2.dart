import 'package:flutter/material.dart';
import '../../menu_menu/paket_data/paket_data_page3.dart';

class PaketDataPage2 extends StatelessWidget {
  final String nomorHp;
  const PaketDataPage2({super.key, required this.nomorHp});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> paketList = [
      {'kuota': '3GB', 'masa': '30 Hari', 'harga': 'Rp26.500'},
      {'kuota': '8GB', 'masa': '28 Hari', 'harga': 'Rp61.500'},
      {'kuota': '13GB', 'masa': '28 Hari', 'harga': 'Rp98.500'},
      {'kuota': '1GB', 'masa': '1 Hari', 'harga': 'Rp6.500'},
      {'kuota': '80GB', 'masa': '30 Hari', 'harga': 'Rp118.500'},
    ];

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: const [
                      Text('Paket Data Internet',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      Text('Pilih Paket Internet Anda',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text('Nomor: $nomorHp',
                    style: const TextStyle(
                        color: Colors.black87, fontSize: 16)),
                const SizedBox(height: 20),
                Column(
                  children: paketList.map((paket) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaketDataPage3(
                              kuota: paket['kuota']!,
                              harga: paket['harga']!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 3))
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${paket['kuota']} (${paket['masa']})',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87)),
                            Text(paket['harga']!,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF2196F3),
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
