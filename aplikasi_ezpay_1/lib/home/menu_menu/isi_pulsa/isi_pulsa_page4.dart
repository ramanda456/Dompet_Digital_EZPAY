import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../menu_menu/isi_pulsa/isi_pulsa_page5.dart';
import '../../../../services/api_service.dart';

class IsiPulsaPage4 extends StatefulWidget {
  final String nomorHp;
  final String nominal;
  final String harga;

  const IsiPulsaPage4({
    super.key,
    required this.nomorHp,
    required this.nominal,
    required this.harga,
  });

  @override
  State<IsiPulsaPage4> createState() => _IsiPulsaPage4State();
}

class _IsiPulsaPage4State extends State<IsiPulsaPage4> {
  String pin = "";
  bool _isSubmitting = false;

  void _addNumber(String number) {
    if (pin.length < 6) {
      setState(() {
        pin += number;
      });
    }
  }

  void _removeNumber() {
    if (pin.isNotEmpty) {
      setState(() {
        pin = pin.substring(0, pin.length - 1);
      });
    }
  }

  Future<void> _onConfirm() async {
    if (pin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan 6 digit PIN')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Panggil API PPOB purchase
      // Untuk demo, kita gunakan productId = 1 (pulsa)
      // Di real app, productId bisa di-lookup dari API ppob/products
      final result = await ApiService.instance.ppobPurchase(
        productId: 1, // ID produk pulsa dari database
        customerNumber: widget.nomorHp,
        pin: pin,
      );

      if (kDebugMode) debugPrint('PPOB Pulsa result: $result');

      if (!mounted) return;

      if (result['success'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => IsiPulsaPage5(
              nomorHp: widget.nomorHp,
              nominal: widget.nominal,
              harga: widget.harga,
              transactionCode: result['data']?['transaction_code'] ?? '-',
              serialNumber: result['data']?['serial_number'] ?? '-',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Pembelian pulsa gagal'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => pin = "");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

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
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Masukkan PIN Anda',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          final filled = index < pin.length;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 44,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: filled
                                  ? const Icon(Icons.circle,
                                      size: 12, color: Colors.black)
                                  : const SizedBox(),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3F51B5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: _isSubmitting ? null : _onConfirm,
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Konfirmasi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildNumberRow(['1', '2', '3']),
                    buildNumberRow(['4', '5', '6']),
                    buildNumberRow(['7', '8', '9']),
                    buildNumberRow(['', '0', '⌫']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk baris tombol angka
  Widget buildNumberRow(List<String> numbers) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: numbers.map((num) {
          if (num == '⌫') {
            return IconButton(
              icon: const Icon(Icons.backspace_outlined, size: 28),
              onPressed: _removeNumber,
            );
          } else if (num.isEmpty) {
            return const SizedBox(width: 60);
          } else {
            return GestureDetector(
              onTap: () => _addNumber(num),
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  num,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            );
          }
        }).toList(),
      ),
    );
  }
}
