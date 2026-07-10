import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login_page/login_page1.dart';
import 'lupa_sandi_page2.dart';
import '../../widgets/gradient_button.dart';

/// Langkah 1 lupa sandi: masukkan email (Firebase mengirim link reset).
class LupaSandiPage1 extends StatefulWidget {
  const LupaSandiPage1({super.key});

  @override
  State<LupaSandiPage1> createState() => _LupaSandiPage1State();
}

class _LupaSandiPage1State extends State<LupaSandiPage1> {
  final _email = TextEditingController();
  bool _loading = false;

  Future<void> _kirimLinkReset() async {
    final email = _email.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan alamat email yang valid')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LupaSandiPage2(email: email),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Gagal mengirim email reset')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  InputDecoration _inputDeco() => InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintText: 'contoh@email.com',
        hintStyle: const TextStyle(
          color: Colors.black54,
          fontFamily: 'Poppins',
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      );

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage1()),
                    );
                  },
                ),
                SizedBox(height: h * 0.02),
                const Center(
                  child: Text(
                    'Lupa Sandi',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Masukkan email akun EZ Pay Anda. Kami akan mengirimkan link '
                      'untuk mengatur ulang sandi.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.05),
                const Text(
                  'Email',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                  decoration: _inputDeco(),
                ),
                SizedBox(height: h * 0.06),
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
                    onPressed: _loading ? () {} : _kirimLinkReset,
                    child: _loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Lanjutkan',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
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
