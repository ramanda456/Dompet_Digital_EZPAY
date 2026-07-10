import 'package:flutter/material.dart';
import '../isi_saldo_uang_tunai_indomaret/isi_saldo_uang_tunai_indomaret_page3.dart';

class IsiSaldoUangTunaiIndomaretPage2 extends StatefulWidget {
  const IsiSaldoUangTunaiIndomaretPage2({super.key});

  @override
  State<IsiSaldoUangTunaiIndomaretPage2> createState() => _IsiSaldoUangTunaiIndomaretPage2State();
}

class _IsiSaldoUangTunaiIndomaretPage2State extends State<IsiSaldoUangTunaiIndomaretPage2> {
  String pin = "";

  void _onKeyTap(String value) {
    if (pin.length < 4) {
      setState(() {
        pin += value;
      });
    }
  }

  void _onBackspace() {
    if (pin.isNotEmpty) {
      setState(() {
        pin = pin.substring(0, pin.length - 1);
      });
    }
  }

  void _onConfirm() {
    if (pin.length == 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PIN berhasil dikonfirmasi")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IsiSaldoUangTunaiIndomaretPage3()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan 4 digit PIN Anda")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Masukkan PIN Anda',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 50),

            // --- PIN Input Boxes ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                bool filled = index < pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    filled ? "•" : "",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            // --- Tombol Konfirmasi ---
            SizedBox(
              width: 220,
              height: 48,
              child: ElevatedButton(
                onPressed: _onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D5AFE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  "Konfirmasi",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // --- Keyboard Numerik ---
            Container(
              padding: const EdgeInsets.only(bottom: 20, top: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  for (var row in [
                    ['1', '2', '3'],
                    ['4', '5', '6'],
                    ['7', '8', '9'],
                    ['⌄', '0', '⌫']
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: row.map((key) {
                          return _buildKeyButton(key);
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyButton(String key) {
    return GestureDetector(
      onTap: () {
        if (key == '⌫') {
          _onBackspace();
        } else if (key == '⌄') {
          FocusScope.of(context).unfocus();
        } else {
          _onKeyTap(key);
        }
      },
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        child: key == '⌫'
            ? const Icon(Icons.backspace_outlined, size: 28, color: Colors.black54)
            : Text(
                key,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }
}
