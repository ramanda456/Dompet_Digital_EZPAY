import 'package:flutter/material.dart';

import '../login_page/login_page1.dart';
import '../../widgets/gradient_button.dart';

/// Setelah Firebase mengirim email reset: instruksi klik link, lalu kembali login.
class LupaSandiPage2 extends StatelessWidget {
  const LupaSandiPage2({
    super.key,
    required this.email,
  });

  final String email;

  void _keLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage1(
          snackMessage:
              'Buka email Anda, ketuk link reset sandi, lalu masuk dengan sandi baru.',
        ),
      ),
      (route) => false,
    );
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
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(height: h * 0.06),
                Center(
                  child: Icon(
                    Icons.mail_outline_rounded,
                    size: h * 0.12,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: h * 0.04),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Klik link reset password yang telah kami kirimkan ke email anda',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      height: 1.45,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          email,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Periksa juga folder spam jika tidak terlihat di inbox.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Colors.black.withValues(alpha: 0.65),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
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
                    onPressed: () => _keLogin(context),
                    child: const Text(
                      'Kembali ke login',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
