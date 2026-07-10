import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../../widgets/gradient_button.dart';
import '../../../login/lupa_sandi_page/lupa_sandi_page1.dart';
import '../../../login/register_page/register_page1.dart';
import '../../../home/home_screen.dart';
import '../../../services/api_service.dart';

class LoginPage1 extends StatefulWidget {
  const LoginPage1({super.key, this.snackMessage});

  /// Ditampilkan sekali setelah navigasi (mis. setelah daftar berhasil).
  final String? snackMessage;

  @override
  State<LoginPage1> createState() => _LoginPage1State();
}

class _LoginPage1State extends State<LoginPage1> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    final msg = widget.snackMessage;
    if (msg != null && msg.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      });
    }
  }

  /// Web client ID (client_type 3) dari `android/app/google-services.json` —
  /// diperlukan agar `idToken` terisi untuk Firebase Auth di Android.
  static const String _googleWebClientId =
      '109147863197-opu5l8mrqbqrp7o8o665569pvsbqc9e2.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const <String>['email', 'profile'],
    serverClientId: _googleWebClientId,
  );

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Sync login ke Laravel API (MySQL) setelah Firebase Auth berhasil.
  Future<void> _syncToApi(User user) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final apiResult = await ApiService.instance.login(
        firebaseUid: user.uid,
        fcmToken: fcmToken,
        deviceInfo: 'Android',
      );

      if (kDebugMode) {
        debugPrint('API Login result: $apiResult');
      }

      if (apiResult['success'] != true) {
        final code = apiResult['code'];
        if (code == 'USER_NOT_FOUND' && mounted) {
          // User ada di Firebase tapi belum register di MySQL
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Akun belum terdaftar di database. Silakan daftar ulang.',
              ),
              duration: Duration(seconds: 4),
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Sync MySQL: ${apiResult['message'] ?? 'Gagal'}',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('API sync error: $e');
    }
  }

  // =========================
  // 🔥 GOOGLE LOGIN FUNCTION
  // =========================
  Future<void> signInWithGoogle() async {
    try {
      setState(() => isLoading = true);

      FirebaseCrashlytics.instance.log(
        "User mencoba login menggunakan Google",
      );

      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn();

      if (googleUser == null) {
        FirebaseCrashlytics.instance.setCustomKey(
          "google_login",
          "dibatalkan_user",
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Login Google gagal: token tidak didapat. Periksa SHA-1 di Firebase dan Web client ID.',
              ),
            ),
          );
        }
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      // Sync ke Laravel API (MySQL)
      await _syncToApi(_auth.currentUser!);

      FirebaseCrashlytics.instance.setUserIdentifier(
        _auth.currentUser!.uid,
      );
      FirebaseCrashlytics.instance.setCustomKey(
        "login_method",
        "google",
      );
      FirebaseCrashlytics.instance.log("Login Google berhasil");

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Error saat login Google",
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e is FirebaseAuthException
                  ? (e.message ?? 'Login Google gagal')
                  : 'Login Google gagal',
            ),
          ),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  // =========================
  // 🔐 LOGIN EMAIL + SANDI (Firebase Auth)
  // =========================
  Future<void> loginManual() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Isi email dan sandi')),
        );
      }
      return;
    }

    FirebaseCrashlytics.instance.log("User menekan tombol login manual");
    FirebaseCrashlytics.instance.setCustomKey("login_method", "email_password");

    setState(() => isLoading = true);

    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Sync ke Laravel API (MySQL)
      await _syncToApi(cred.user!);

      FirebaseCrashlytics.instance.setUserIdentifier(cred.user!.uid);
      FirebaseCrashlytics.instance.log("Login email berhasil");

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Error saat login email",
      );
      String message;
      switch (e.code) {
        case 'invalid-credential':
          message =
              'Email/sandi tidak cocok. Jika akun dibuat dengan Google (ikon G di Firebase), login pakai tombol Google.';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        case 'too-many-requests':
          message = 'Terlalu banyak percobaan login. Coba lagi beberapa saat.';
          break;
        default:
          message = e.message ?? 'Login gagal';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: w,
            height: h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4CAF50),
                  Color(0xFF2196F3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Column(
            children: [
              SizedBox(height: h * 0.13),

              Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'assets/image/user_icon.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 22),

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final kb = MediaQuery.viewInsetsOf(context).bottom;
                    return SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.only(bottom: kb + 16),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: const BoxDecoration(
                                color: Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                              child: const Column(
                                children: [
                                  Text(
                                    "Selamat Datang !",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "Silahkan Lanjut Ke akun Anda",
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              color: Colors.white,
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Email"),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      hintText: "Masukkan email terdaftar",
                                      filled: true,
                                      fillColor: const Color(0xFF4CA5EE)
                                          .withValues(alpha: 0.19),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  const Text("Sandi"),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      hintText: "Masukkan Password",
                                      filled: true,
                                      fillColor: const Color(0xFF4CA5EE)
                                          .withValues(alpha: 0.19),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () => _navigateTo(
                                        context,
                                        const LupaSandiPage1(),
                                      ),
                                      child: const Text("Lupa Sandi?"),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  GradientButton(
                                    width: double.infinity,
                                    height: 48,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4CA5EE),
                                        Color(0xFF2196F3),
                                      ],
                                    ),
                                    borderRadius: 25,
                                    onPressed:
                                        isLoading ? () {} : loginManual,
                                    child: const Text(
                                      "Masuk",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : OutlinedButton.icon(
                                          onPressed: signInWithGoogle,
                                          icon: const Icon(Icons.login),
                                          label: const Text(
                                            "Login dengan Google",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            minimumSize: const Size(
                                              double.infinity,
                                              48,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(height: 18),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Belum punya akun? "),
                                      GestureDetector(
                                        onTap: () => _navigateTo(
                                          context,
                                          const RegisterPage1(),
                                        ),
                                        child: const Text(
                                          "Daftar",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
