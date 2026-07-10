import 'package:flutter/material.dart';

class TopUpEwalletShoppePayPage6 extends StatefulWidget {
  const TopUpEwalletShoppePayPage6({super.key});

  @override
  State<TopUpEwalletShoppePayPage6> createState() =>
      _TopUpEwalletShoppePayPage6State();
}

class _TopUpEwalletShoppePayPage6State
    extends State<TopUpEwalletShoppePayPage6> {
  final List<String> pin = ["", "", "", ""];
  int currentIndex = 0;

  void _addDigit(String value) {
    if (currentIndex < 4) {
      setState(() {
        pin[currentIndex] = value;
        currentIndex++;
      });
    }
  }

  void _removeDigit() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        pin[currentIndex] = "";
      });
    }
  }

  void _confirmPin() {
    if (pin.contains("")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap masukkan PIN lengkap")),
      );
    } else {
      String pinValue = pin.join();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PIN Dikonfirmasi: $pinValue")),
      );
    }
  }

  Widget _buildPinBox(String value) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black54, width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        value.isEmpty ? "" : "●",
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _addDigit(number),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          number,
          style: const TextStyle(fontSize: 24, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: Column(
        children: [
          for (var row in [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"],
            ["", "0", "⌫"]
          ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row.map((value) {
                  if (value == "") {
                    return const SizedBox(width: 60);
                  } else if (value == "⌫") {
                    return GestureDetector(
                      onTap: _removeDigit,
                      child: const Icon(Icons.backspace_outlined, size: 26),
                    );
                  } else {
                    return _buildNumberButton(value);
                  }
                }).toList(),
              ),
            ),
        ],
      ),
    );
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
              Color(0xFF4CAF50), // Hijau atas
              Color(0xFF2196F3), // Biru bawah
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Masukkan PIN Anda',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // PIN INPUT BOXES
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: pin.map((digit) => _buildPinBox(digit)).toList(),
              ),

              const SizedBox(height: 40),

              // TOMBOL KONFIRMASI
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: _confirmPin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F51B5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Konfirmasi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // NUMPAD
              _buildKeyboard(),
            ],
          ),
        ),
      ),
    );
  }
}
