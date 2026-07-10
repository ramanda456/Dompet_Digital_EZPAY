import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../services/api_service.dart';
import '../../../services/user_firestore_service.dart'; // formatSaldoIdr

// import halaman navigasi bawah
import '../../../home/home_screen.dart';
import '../../../home/nav_menu/riwayat/riwayat_transaksi.dart';
import '../../../home/nav_menu/pesan/pesan.dart';

// import halaman masing-masing menu profil

import '../../nav_menu/profil/pengaturan_profil/pengaturan_profil.dart';
import '../../nav_menu/profil/ganti_pin/ganti_pin_page1.dart';
import '../../nav_menu/profil/syarat_ketentuan/syarat_ketentuan.dart';
import '../../nav_menu/profil/kebijakan_privasi/kebijakan_privasi.dart';
import '../../nav_menu/profil/tentang_saya/tentang_saya.dart';
import '../../../login/login_page/login_page1.dart';


class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  int _selectedIndex = 3;
  bool _saldoVisible = true;

  // Data dari API MySQL
  String _displayName = 'Pengguna';
  String _phone = 'Belum diatur';
  int _balance = 0;
  String? _photoUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    _photoUrl = user?.photoURL?.trim();

    try {
      if (ApiService.instance.isLoggedIn) {
        final res = await ApiService.instance.getProfile();
        if (res['success'] == true && res['data'] != null) {
          final data = res['data'];
          _displayName = data['name'] ?? user?.displayName ?? 'Pengguna';
          _phone = data['phone'] ?? 'Belum diatur';
          _balance = (data['balance'] is num)
              ? (data['balance'] as num).toInt()
              : int.tryParse('${data['balance']}') ?? 0;
        } else {
          _displayName = user?.displayName ?? user?.email?.split('@').first ?? 'Pengguna';
        }
      } else {
        _displayName = user?.displayName ?? user?.email?.split('@').first ?? 'Pengguna';
      }
    } catch (e) {
      if (kDebugMode) debugPrint('ProfilPage _loadProfile error: $e');
      _displayName = user?.displayName ?? 'Pengguna';
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _logout() async {
    // Logout dari API Laravel
    try {
      await ApiService.instance.logout();
    } catch (_) {}

    // Logout dari Google Sign-In
    try {
      await GoogleSignIn().signOut();
    } catch (_) {
      // Tidak masalah jika user tidak login via Google.
    }

    await FirebaseAuth.instance.signOut();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage1()),
      (route) => false,
    );
  }

  void _onNavTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const RiwayatTransaksi()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const PesanMasukPage()));
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: h * 0.24,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF4F6F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Profil',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===== Card Info Profil (dari API MySQL) =====
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(30),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: (_photoUrl != null &&
                                        _photoUrl!.isNotEmpty)
                                    ? NetworkImage(_photoUrl!)
                                    : const AssetImage(
                                            'assets/image/avatar_user.png')
                                        as ImageProvider,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _displayName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                _phone,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Divider(height: 1),
                              const SizedBox(height: 12),
                              const Text(
                                'Saldo EZ Pay',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _saldoVisible
                                        ? formatSaldoIdr(_balance)
                                        : '••••••',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _saldoVisible = !_saldoVisible;
                                      });
                                    },
                                    child: Icon(
                                      _saldoVisible
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 22,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _menuItem(Icons.person, "Pengaturan Profil", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PengaturanProfilPage()),
                          );
                        }),
                        _menuItem(Icons.lock, "Ganti PIN", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const GantiPinPage1()),
                          );
                        }),
                        _menuItem(Icons.receipt_long, "Riwayat", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RiwayatTransaksi()),
                          );
                        }),
                        _menuItem(Icons.shield_outlined, "Syarat & Ketentuan", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SyaratKetentuanPage()),
                          );
                        }),
                        _menuItem(Icons.privacy_tip_outlined, "Kebijakan Privasi", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const KebijakanPrivasiPage()),
                          );
                        }),
                        _menuItem(Icons.menu_rounded, "Tentang Saya", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TentangSayaPage()),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GestureDetector(
                      onTap: _logout,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.logout, color: Color(0xFF4CA5EE)),
                            SizedBox(width: 6),
                            Text(
                              "Keluar",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),

      // ===== Bottom Navigation Bar =====
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomNavItem(
              icon: Icons.home,
              label: "Beranda",
              isActive: false,
              onTap: () => _onNavTapped(0),
            ),
            _BottomNavItem(
              icon: Icons.receipt_long,
              label: "Riwayat",
              isActive: false,
              onTap: () => _onNavTapped(1),
            ),
            _BottomNavItem(
              icon: Icons.notifications,
              label: "Pesan",
              isActive: false,
              onTap: () => _onNavTapped(2),
            ),
            _BottomNavItem(
              icon: Icons.person,
              label: "Profil",
              isActive: true,
              onTap: () => _onNavTapped(3),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Widget Menu Item =====
  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF4CA5EE)),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.black54,
        ),
        onTap: onTap,
      ),
    );
  }
}

// ===== Komponen Navbar Item =====
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? Colors.white : Colors.white70),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              color: isActive ? Colors.white : Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
