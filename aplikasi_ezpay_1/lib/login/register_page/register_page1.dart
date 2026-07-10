import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../login/login_page/login_page1.dart';
import '../../../widgets/gradient_button.dart';
import '../../../services/api_service.dart';
import '../../home/home_screen.dart';

class RegisterPage1 extends StatefulWidget {
  const RegisterPage1({super.key});

  @override
  State<RegisterPage1> createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  final _nama = TextEditingController();
  final _hp = TextEditingController();
  final _nik = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _pin = TextEditingController();
  String? _gender;

  bool _isSubmitting = false;

  Future<void> _daftarAkun() async {
    final nama = _nama.text.trim();
    final email = _email.text.trim();
    final pass = _pass.text;
    final hp = _hp.text.trim();
    final nik = _nik.text.trim();
    final pin = _pin.text.trim();

    if (nama.isEmpty ||
        hp.isEmpty ||
        nik.isEmpty ||
        email.isEmpty ||
        pass.isEmpty ||
        pin.isEmpty ||
        _gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua field')),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email tidak valid')),
      );
      return;
    }

    if (pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sandi minimal 6 karakter')),
      );
      return;
    }

    if (pin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN harus 6 digit')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // 1. Register di Firebase Auth
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      await cred.user?.updateDisplayName(nama);

      // 2. Register di MySQL via Laravel API
      final apiResult = await ApiService.instance.register(
        firebaseUid: cred.user!.uid,
        name: nama,
        email: email,
        phone: hp,
        nik: nik,
        gender: _gender!,
        pin: pin,
      );

      if (kDebugMode) {
        debugPrint('API Register result: $apiResult');
      }

      if (apiResult['success'] != true) {
        // Jika gagal di MySQL, tampilkan pesan tapi tetap lanjut
        // karena akun Firebase sudah terbuat
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Akun Firebase dibuat. MySQL: ${apiResult['message'] ?? 'Gagal sync'}',
              ),
            ),
          );
        }
      }

      // 3. Kirim FCM token ke backend
      try {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null && ApiService.instance.isLoggedIn) {
          await ApiService.instance.storeFcmToken(fcmToken: fcmToken);
        }
      } catch (e) {
        if (kDebugMode) debugPrint('FCM token sync error: $e');
      }

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Pendaftaran gagal')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  InputDecoration _darkFieldDeco() => InputDecoration(
        filled: true,
        fillColor: const Color(0xFF146A6F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white70,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: w,
        height: h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView( // 👈 ini kuncinya agar tidak overflow
          padding: EdgeInsets.fromLTRB(w * 0.08, h * 0.07, w * 0.08, h * 0.05),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/image/money_icon.png',
                  width: 140,
                  height: 140,
                ),
              ),
              const SizedBox(height: 12),

              // ===== Input Form =====
              const Text(
                'Nama Lengkap',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nama,
                style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                decoration: _darkFieldDeco(),
              ),

              const SizedBox(height: 14),
              const Text(
                'Jenis Kelamin',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF146A6F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _gender,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                    dropdownColor: const Color(0xFF146A6F),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Laki-laki', child: Text('Laki-laki')),
                      DropdownMenuItem(
                          value: 'Perempuan', child: Text('Perempuan')),
                    ],
                    onChanged: (v) => setState(() => _gender = v),
                    hint: const Text(
                      'Pilih Jenis Kelamin',
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),
              const Text(
                'No. Handphone',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _hp,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                decoration: _darkFieldDeco(),
              ),

              const SizedBox(height: 14),
              const Text(
                'NIK',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nik,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                decoration: _darkFieldDeco(),
              ),

              const SizedBox(height: 14),
              const Text(
                'Email',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                decoration: _darkFieldDeco(),
              ),

              const SizedBox(height: 14),
              const Text(
                'Sandi',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _pass,
                obscureText: true,
                style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                decoration: _darkFieldDeco(),
              ),

              const SizedBox(height: 14),
              const Text(
                'PIN (6 digit)',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _pin,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                decoration: _darkFieldDeco().copyWith(
                  counterStyle: const TextStyle(color: Colors.white70),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: GradientButton(
                  width: w * 0.85,
                  height: 52,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CA5EE), Color(0xFF2196F3)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  hoverColor: const Color(0xFF4CAF50),
                  borderRadius: 30,
                  onPressed: _isSubmitting ? () {} : _daftarAkun,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Daftar Akun',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 14),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage1()),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Sudah Punya Akun? ',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF4CAF50), // hijau
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: 'Masuk',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white, // putih
                            fontWeight: FontWeight.w700,
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
    );
  }
}
