import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/user_firestore_service.dart'; // untuk formatSaldoIdr

// === IMPORT SESUAI STRUKTUR KAMU ===
import '../home/isi_saldo/isi_saldo.dart';
import '../home/transfer/transfer.dart';
import '../home/tarik_tunai/tarik_tunai.dart';
import '../home/top_up/top_up.dart';

import '../home/menu_menu/isi_pulsa/isi_pulsa_page1.dart';
import '../home/menu_menu/paket_data/paket_data_page1.dart';
import '../home/menu_menu/listrik/bayar_listrik_page1.dart';
import '../home/menu_menu/top_up_game/top_up_game.dart';
import '../home/menu_menu/bpjs/bpjs_page1.dart';
import '../home/menu_menu/pdam/bayar_pdam_page1.dart';

import '../home/banner_promo/banner_promo1/banner_promo1_page1.dart';
import '../home/banner_promo/banner_promo2/banner_promo2_page1.dart';


import '../home/nav_menu/pesan/pesan.dart';
import '../home/nav_menu/profil/profil.dart';
import '../home/nav_menu/riwayat/riwayat_transaksi.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _saldoVisible = true;

  // Data dari API MySQL
  String _displayName = 'Pengguna';
  int _balance = 0;
  List<Map<String, dynamic>> _recentTransactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Fallback ke Firebase Auth untuk nama jika API belum ready
    final user = FirebaseAuth.instance.currentUser;

    try {
      // Ambil profil dan saldo dari MySQL API
      if (ApiService.instance.isLoggedIn) {
        final profileRes = await ApiService.instance.getProfile();
        if (profileRes['success'] == true) {
          final data = profileRes['data'];
          _displayName = data['name'] ?? user?.displayName ?? 'Pengguna';
          _balance = double.tryParse('${data['balance']}')?.toInt() ?? 0;
        } else {
          // Fallback ke Firebase Auth
          _displayName = user?.displayName ?? user?.email?.split('@').first ?? 'Pengguna';
        }

        // Ambil riwayat transaksi terakhir
        final txRes = await ApiService.instance.getTransactions(limit: 4);
        if (txRes['success'] == true && txRes['data'] != null) {
          final txData = txRes['data'];
          // Handle paginated response (data bisa di 'data' atau langsung array)
          if (txData is List) {
            _recentTransactions = List<Map<String, dynamic>>.from(txData);
          } else if (txData is Map && txData['data'] is List) {
            _recentTransactions = List<Map<String, dynamic>>.from(txData['data']);
          }
        }
      } else {
        // Belum login ke API, gunakan data Firebase
        _displayName = user?.displayName ?? user?.email?.split('@').first ?? 'Pengguna';
      }
    } catch (e) {
      if (kDebugMode) debugPrint('HomeScreen _loadData error: $e');
      _displayName = user?.displayName ?? 'Pengguna';
    }

    if (mounted) setState(() => _isLoading = false);
  }

  String _getTransactionIcon(String? type) {
    switch (type) {
      case 'transfer_ezpay':
        return 'assets/image/icon_ezpay.png';
      case 'transfer_bank':
        return 'assets/image/icon_bsi.png';
      case 'transfer_ewallet':
        return 'assets/image/icon_dana.png';
      case 'topup':
        return 'assets/image/icon_plus.png';
      case 'tarik_tunai':
        return 'assets/image/icon_tarik_tunai.png';
      case 'ppob_pulsa':
        return 'assets/image/icon_telepon.png';
      case 'ppob_data':
        return 'assets/image/icon_data.png';
      case 'ppob_listrik':
        return 'assets/image/listrik_icon.png';
      case 'ppob_pdam':
        return 'assets/image/pdam_icon.png';
      case 'ppob_bpjs':
        return 'assets/image/icon_bpjs.png';
      case 'ppob_game':
        return 'assets/image/game_icon.png';
      default:
        return 'assets/image/icon_ezpay.png';
    }
  }

  String _getTransactionLabel(String? type) {
    switch (type) {
      case 'transfer_ezpay': return 'Transfer EZ Pay';
      case 'transfer_bank': return 'Transfer Bank';
      case 'transfer_ewallet': return 'Transfer E-Wallet';
      case 'topup': return 'Top Up Saldo';
      case 'tarik_tunai': return 'Tarik Tunai';
      case 'ppob_pulsa': return 'Beli Pulsa';
      case 'ppob_data': return 'Beli Paket Data';
      case 'ppob_listrik': return 'Bayar Listrik';
      case 'ppob_pdam': return 'Bayar PDAM';
      case 'ppob_bpjs': return 'Bayar BPJS';
      case 'ppob_game': return 'Top Up Game';
      default: return type ?? 'Transaksi';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // ===== HEADER =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/image/money_icon.png',
                        width: 80,
                      ),
                      const SizedBox(height: 12),

                      // === SELAMAT DATANG & SALDO (dari API MySQL) ===
                      _isLoading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.white,
                                      child:
                                          Icon(Icons.person, color: Colors.blue),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Selamat datang,",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                        Text(
                                          _displayName.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "Saldo EZ Pay",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          _saldoVisible
                                              ? formatSaldoIdr(_balance)
                                              : "******",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _saldoVisible = !_saldoVisible;
                                            });
                                          },
                                          child: Icon(
                                            _saldoVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      const SizedBox(height: 18),

                      // === MENU UTAMA ===
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _menuTopItem(context, 'assets/image/icon_isi_saldo.png',
                                'Isi saldo', const IsiSaldoPage()),
                            _menuTopItem(context, 'assets/image/icon_transfer.png',
                                'Transfer', const TransferPage()),
                            _menuTopItem(context, 'assets/image/icon_tarik_tunai.png',
                                'Tarik tunai', const TarikTunaiPage()),
                            _menuTopItem(context, 'assets/image/icon_top_up.png',
                                'Top up', const TopUpPage()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // ===== MENU KATEGORI =====
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _menuCategory(context, 'assets/image/icon_pulsa.png',
                              'Pulsa', const IsiPulsaPage1()),
                          _menuCategory(context, 'assets/image/icon_data.png',
                              'Data', const PaketDataPage1()),
                          _menuCategory(context, 'assets/image/icon_listrik.png',
                              'Listrik', const BayarListrikPage1()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _menuCategory(context, 'assets/image/icon_game.png',
                              'Game', const TopUpGamePage()),
                          _menuCategory(context, 'assets/image/icon_bpjs.png',
                              'BPJS', const BpjsPage1()),
                          _menuCategory(context, 'assets/image/icon_pdam.png',
                              'PDAM', const BayarPdamPage1()),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ===== BANNER 1 =====
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _bannerItem(context, 'assets/image/banner1.png',
                          const BannerPromo1Page1()),
                      _bannerItem(context, 'assets/image/banner2.png',
                          const BannerPromo1Page1()),
                      _bannerItem(context, 'assets/image/banner3.png',
                          const BannerPromo1Page1()),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ===== BANNER 2 =====
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _bannerItem(context, 'assets/image/banner4.png',
                          const BannerPromo2Page1()),
                      _bannerItem(context, 'assets/image/banner5.png',
                          const BannerPromo2Page1()),
                      _bannerItem(context, 'assets/image/banner6.png',
                          const BannerPromo2Page1()),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ===== RIWAYAT TRANSAKSI (dari API MySQL) =====
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Riwayat Transaksi terakhir",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_recentTransactions.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              'Belum ada transaksi',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        )
                      else
                        ..._recentTransactions.map((tx) {
                          final type = tx['type'] as String?;
                          final amount = (tx['amount'] is num)
                              ? (tx['amount'] as num).toInt()
                              : int.tryParse('${tx['amount']}') ?? 0;
                          final isCredit = type == 'topup';
                          final amountStr = isCredit
                              ? '+${formatSaldoIdr(amount)}'
                              : '-${formatSaldoIdr(amount)}';
                          final date = tx['created_at'] as String? ?? '';
                          final desc = tx['description'] as String? ?? '';
                          final recipientName = tx['recipient_name'] as String? ?? desc;
                          final code = tx['transaction_code'] as String? ?? '';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _transactionItem(
                              _getTransactionIcon(type),
                              recipientName,
                              code,
                              amountStr,
                              date.length >= 10 ? date.substring(0, 10) : date,
                              _getTransactionLabel(type),
                            ),
                          );
                        }),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),

      // ===== NAV BAWAH =====
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
              isActive: true,
              onTap: () {},
            ),
            _BottomNavItem(
              icon: Icons.receipt_long,
              label: "Riwayat",
              isActive: false,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RiwayatTransaksi())),
            ),
            _BottomNavItem(
              icon: Icons.notifications,
              label: "Pesan",
              isActive: false,
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const PesanMasukPage())),
            ),
            _BottomNavItem(
              icon: Icons.person,
              label: "Profil",
              isActive: false,
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const ProfilPage())),
            ),
          ],
        ),
      ),
    );
  }
}

// ==== COMPONENTS ====

Widget _menuTopItem(BuildContext context, String icon, String label, Widget page) {
  return GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(icon, width: 40, height: 40),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12)),
      ],
    ),
  );
}

Widget _menuCategory(
    BuildContext context, String icon, String label, Widget page) {
  return GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
    child: Column(
      children: [
        Image.asset(icon, width: 40, height: 40),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontFamily: 'Poppins')),
      ],
    ),
  );
}

Widget _bannerItem(BuildContext context, String img, Widget page) {
  return GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
    child: Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(img, fit: BoxFit.cover),
    ),
  );
}

// ===== Transaction Item =====
Widget _transactionItem(String icon, String name, String desc, String amount,
    String date, String title) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2)),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(icon, width: 35, height: 35),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.black54)),
              Text(name,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              Text(desc,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.black54)),
              Text(date,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Colors.black54)),
            ],
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: amount.startsWith('+') ? Colors.green : Colors.redAccent,
          ),
        ),
      ],
    ),
  );
}




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
