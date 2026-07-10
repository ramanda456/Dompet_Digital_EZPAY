import 'package:flutter/material.dart';
import '../../tarik_tunai_lewat_merchant/tarik_tunai_lewat_merchant_indomaret/tarik_tunai_lewat_merchant_indomaret_page4.dart';

class TarikTunaiLewatMerchantIndomaretPage3 extends StatefulWidget {
  const TarikTunaiLewatMerchantIndomaretPage3({super.key});

  @override
  State<TarikTunaiLewatMerchantIndomaretPage3> createState() =>
      _TarikTunaiLewatMerchantIndomaretPage3State();
}

class _TarikTunaiLewatMerchantIndomaretPage3State
    extends State<TarikTunaiLewatMerchantIndomaretPage3> {
  String enteredPin = '';

  void _addDigit(String digit) {
    if (enteredPin.length < 6) {
      setState(() {
        enteredPin += digit;
      });
    }
  }

  void _removeDigit() {
    if (enteredPin.isNotEmpty) {
      setState(() {
        enteredPin = enteredPin.substring(0, enteredPin.length - 1);
      });
    }
  }

  void _confirmPin() {
    if (enteredPin.length == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TarikTunaiLewatMerchantIndomaretPage4(),
        ),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan 6 digit PIN terlebih dahulu")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Masukkan PIN Anda",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // PIN boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  bool filled = index < enteredPin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 45,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        filled ? "•" : "",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              // Tombol konfirmasi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _confirmPin,
                  child: const Text(
                    "Konfirmasi",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Numpad
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  children: [
                    _buildNumberRow(['1', '2', '3']),
                    const SizedBox(height: 16),
                    _buildNumberRow(['4', '5', '6']),
                    const SizedBox(height: 16),
                    _buildNumberRow(['7', '8', '9']),
                    const SizedBox(height: 16),
                    _buildNumberRow(['', '0', '<']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((digit) {
        if (digit == '<') {
          return _numButton(
            icon: Icons.backspace_outlined,
            onTap: _removeDigit,
          );
        } else if (digit.isEmpty) {
          return const SizedBox(width: 60);
        } else {
          return _numButton(
            text: digit,
            onTap: () => _addDigit(digit),
          );
        }
      }).toList(),
    );
  }

  Widget _numButton({String? text, IconData? icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: icon != null
            ? Icon(icon, size: 26, color: Colors.black87)
            : Text(
                text!,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
