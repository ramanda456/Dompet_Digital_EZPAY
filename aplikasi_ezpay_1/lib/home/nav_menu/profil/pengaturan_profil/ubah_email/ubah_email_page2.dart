import 'package:flutter/material.dart';

class UbahEmailPage2 extends StatefulWidget {
  final String newEmail;

  const UbahEmailPage2({super.key, required this.newEmail});

  @override
  State<UbahEmailPage2> createState() => _UbahEmailPage2State();
}

class _UbahEmailPage2State extends State<UbahEmailPage2> {
  final List<String> _otp = ['', '', '', ''];

  void _onNumberTap(String number) {
    for (int i = 0; i < _otp.length; i++) {
      if (_otp[i].isEmpty) {
        setState(() => _otp[i] = number);
        break;
      }
    }
  }

  void _onBackspace() {
    for (int i = _otp.length - 1; i >= 0; i--) {
      if (_otp[i].isNotEmpty) {
        setState(() => _otp[i] = '');
        break;
      }
    }
  }

  void _onConfirm() {
    if (_otp.contains('')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan kode OTP lengkap terlebih dahulu")),
      );
      return;
    }

    // ✅ Tampilkan pesan sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Email berhasil diganti!"),
        backgroundColor: Colors.green,
      ),
    );

    // ✅ Tunggu sebentar lalu kembali ke pengaturan profil
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // tutup ubah_email_page2
      Navigator.pop(context); // tutup ubah_email_page1 → kembali ke pengaturan_profil.dart
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          // ================= HEADER GRADIENT =================
          Container(
            width: double.infinity,
            height: size.height * 0.38,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        "Masukkan kode verifikasi yang dikirim ke Email anda",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // OTP BOXES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              _otp[index],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // BUTTON KONFIRMASI
                    Center(
                      child: SizedBox(
                        width: 180,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _onConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2962FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Konfirmasi",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // RESEND TEXT
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Kode OTP dikirim ulang ke ${widget.newEmail}"),
                            ),
                          );
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: "Tidak menerima kode OTP? ",
                            style: TextStyle(color: Colors.white),
                            children: [
                              TextSpan(
                                text: "Kirim Ulang",
                                style: TextStyle(
                                  color: Color(0xFF2962FF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ================= KEYPAD =================
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var row in [
                    ['1', '2', '3'],
                    ['4', '5', '6'],
                    ['7', '8', '9'],
                    ['<', '0', '⌫'],
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: row.map((key) => _buildKey(key)).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= KEY BUTTON =================
  Widget _buildKey(String value) {
    return GestureDetector(
      onTap: () {
        if (value == '⌫') {
          _onBackspace();
        } else if (value != '<') {
          _onNumberTap(value);
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)
          ],
        ),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
