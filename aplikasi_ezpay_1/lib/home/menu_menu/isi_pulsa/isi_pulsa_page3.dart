import 'package:flutter/material.dart';
import 'isi_pulsa_page4.dart';
import '../../../../services/api_service.dart';
import '../../../../services/user_firestore_service.dart'; // formatSaldoIdr

class IsiPulsaPage3 extends StatefulWidget {
  final String nomorHp;
  final String nominal;
  final String harga;

  const IsiPulsaPage3({
    super.key,
    required this.nomorHp,
    required this.nominal,
    required this.harga,
  });

  @override
  State<IsiPulsaPage3> createState() => _IsiPulsaPage3State();
}

class _IsiPulsaPage3State extends State<IsiPulsaPage3> {
  int _saldo = 0;
  bool _isLoadingSaldo = true;

  @override
  void initState() {
    super.initState();
    _loadSaldo();
  }

  Future<void> _loadSaldo() async {
    try {
      if (ApiService.instance.isLoggedIn) {
        final res = await ApiService.instance.getSaldo();
        if (res['success'] == true && res['data'] != null) {
          _saldo = (res['data']['balance'] is num)
              ? (res['data']['balance'] as num).toInt()
              : int.tryParse('${res['data']['balance']}') ?? 0;
        }
      }
    } catch (_) {}
    if (mounted) setState(() => _isLoadingSaldo = false);
  }

  @override
  Widget build(BuildContext context) {
    // Konversi harga string ke angka untuk hitung total
    int hargaInt = int.tryParse(widget.harga.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    int admin = 1500;
    int total = hargaInt + admin;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
          ),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Saldo saat ini (dari API)
                const Text(
                  'Saldo anda saat ini',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                _isLoadingSaldo
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        formatSaldoIdr(_saldo),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                const SizedBox(height: 24),

                // Kode Promo
                const Text(
                  'Kode Promo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan kode promo',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black54, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF3F51B5), width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Ringkasan Pembayaran
                const Text(
                  'Ringkasan Pembayaran',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Top Up Pulsa ${widget.nominal}',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87)),
                    Text(widget.harga,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Admin',
                        style: TextStyle(fontSize: 14, color: Colors.black87)),
                    Text('Rp1.500',
                        style: TextStyle(fontSize: 14, color: Colors.black87)),
                  ],
                ),
                const Divider(height: 24, thickness: 1, color: Color(0xFFE0E0E0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Rp$total',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F51B5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Tombol Bayar
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F51B5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IsiPulsaPage4(
                            nomorHp: widget.nomorHp,
                            nominal: widget.nominal,
                            harga: widget.harga,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Bayar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tombol Batal
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }
}
