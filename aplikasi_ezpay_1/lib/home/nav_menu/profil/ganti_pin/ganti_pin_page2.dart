import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart'; // pastikan sudah ditambahkan di pubspec.yaml: pinput: ^3.0.1

class GantiPinPage2 extends StatefulWidget {
  const GantiPinPage2({super.key});

  @override
  State<GantiPinPage2> createState() => _GantiPinPage2State();
}

class _GantiPinPage2State extends State<GantiPinPage2> {
  final TextEditingController otpController = TextEditingController();

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
              Color(0xFF4CAF50), // hijau atas
              Color(0xFF2196F3), // biru bawah
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Tombol kembali
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 40),

              // Judul OTP
              const Text(
                "Masukkan kode OTP yang\ndikirim ke nomor telepon anda",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 30),

              // Input OTP menggunakan Pinput
              Pinput(
                length: 4,
                controller: otpController,
                keyboardType: TextInputType.number,
                obscureText: true,
                obscuringWidget: const Icon(Icons.circle, size: 10, color: Colors.black),
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
              ),
              const SizedBox(height: 30),

              // Tombol Konfirmasi
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F51B5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Tambahkan logika validasi OTP atau navigasi ke halaman berikut
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kode OTP dikonfirmasi!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text(
                    "Konfirmasi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Teks "Kirim Ulang OTP"
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kode OTP telah dikirim ulang!'),
                      backgroundColor: Colors.blueAccent,
                    ),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Tidak Menerima Kode Otp ? ",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                    children: [
                      TextSpan(
                        text: "Kirim Ulang",
                        style: TextStyle(
                          color: Color(0xFF3F51B5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // Keypad visual di bagian bawah
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

  /// Fungsi untuk membuat baris tombol angka di keypad
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
                if (otpController.text.isNotEmpty) {
                  otpController.text =
                      otpController.text.substring(0, otpController.text.length - 1);
                }
              },
            );
          } else if (num.isEmpty) {
            return const SizedBox(width: 60);
          } else {
            return GestureDetector(
              onTap: () {
                if (otpController.text.length < 4) {
                  otpController.text += num;
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
