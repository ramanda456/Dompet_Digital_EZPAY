import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../menu_menu/paket_data/paket_data_page5.dart';

class PaketDataPage4 extends StatefulWidget {
  const PaketDataPage4({super.key});

  @override
  State<PaketDataPage4> createState() => _PaketDataPage4State();
}

class _PaketDataPage4State extends State<PaketDataPage4> {
  final TextEditingController pinController = TextEditingController();

  void _konfirmasi() {
    if (pinController.text.length == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PaketDataPage5()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan 4 digit PIN')),
      );
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
              colors: [Color(0xFF4CAF50), Color(0xFF2196F3)]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white)),
                ),
                const SizedBox(height: 40),
                const Text('Masukkan PIN Anda',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 30),
                Pinput(
                  length: 4,
                  controller: pinController,
                  obscureText: true,
                  obscuringWidget:
                      const Icon(Icons.circle, size: 10, color: Colors.black),
                  defaultPinTheme: PinTheme(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F51B5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    onPressed: _konfirmasi,
                    child: const Text('Konfirmasi',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
