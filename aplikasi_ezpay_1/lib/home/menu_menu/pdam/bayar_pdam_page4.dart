import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../menu_menu/pdam/bayar_pdam_page5.dart';

class BayarPdamPage4 extends StatefulWidget {
  const BayarPdamPage4({super.key});

  @override
  State<BayarPdamPage4> createState() => _BayarPdamPage4State();
}

class _BayarPdamPage4State extends State<BayarPdamPage4> {
  final TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 40),

              const Text(
                'Masukkan PIN Anda',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),

              Pinput(
                length: 4,
                controller: pinController,
                obscureText: true,
                obscuringWidget: const Icon(
                  Icons.circle,
                  size: 10,
                  color: Colors.black,
                ),
                defaultPinTheme: PinTheme(
                  width: 60,
                  height: 60,
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onCompleted: (pin) {},
              ),

              const SizedBox(height: 40),

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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BayarPdamPage5(),
                      ),
                    );
                  },
                  child: const Text(
                    'Konfirmasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Column(
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

  Widget buildNumberRow(List<String> numbers) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: numbers.map((num) {
          if (num == '⌫') {
            return IconButton(
              icon: const Icon(Icons.backspace_outlined, size: 28),
              onPressed: () {
                if (pinController.text.isNotEmpty) {
                  setState(() {
                    pinController.text =
                        pinController.text.substring(0, pinController.text.length - 1);
                  });
                }
              },
            );
          } else if (num.isEmpty) {
            return const SizedBox(width: 60);
          } else {
            return GestureDetector(
              onTap: () {
                if (pinController.text.length < 4) {
                  setState(() {
                    pinController.text += num;
                  });
                }
              },
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
