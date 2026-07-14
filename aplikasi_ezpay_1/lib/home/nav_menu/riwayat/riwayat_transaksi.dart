// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../services/api_service.dart';
import '../../../services/user_firestore_service.dart'; // formatSaldoIdr

// import halaman navigasi bawah
import '../../../home/home_screen.dart';
import '../../../home/nav_menu/pesan/pesan.dart';
import '../../../home/nav_menu/profil/profil.dart';

class RiwayatTransaksi extends StatefulWidget {
  const RiwayatTransaksi({super.key});

  @override
  State<RiwayatTransaksi> createState() => _RiwayatTransaksiState();
}

class _RiwayatTransaksiState extends State<RiwayatTransaksi> {
  int _selectedIndex = 1;

  // Data dari API
  int _balance = 0;
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      if (ApiService.instance.isLoggedIn) {
        // Ambil saldo
        final saldoRes = await ApiService.instance.getSaldo();
        if (saldoRes['success'] == true && saldoRes['data'] != null) {
          _balance = double.tryParse('${saldoRes['data']['balance']}')?.toInt() ?? 0;
        }

        // Ambil riwayat transaksi
        final txRes = await ApiService.instance.getTransactions();
        if (txRes['success'] == true && txRes['data'] != null) {
          final txData = txRes['data'];
          if (txData is List) {
            _transactions = List<Map<String, dynamic>>.from(txData);
          } else if (txData is Map && txData['data'] is List) {
            _transactions = List<Map<String, dynamic>>.from(txData['data']);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('RiwayatTransaksi _loadData error: $e');
    }

    if (mounted) setState(() => _isLoading = false);
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

  String _getTransactionIcon(String? type) {
    switch (type) {
      case 'transfer_ezpay': return 'assets/image/icon_ezpay.png';
      case 'transfer_bank': return 'assets/image/icon_bsi.png';
      case 'transfer_ewallet': return 'assets/image/icon_dana.png';
      case 'topup': return 'assets/image/icon_plus.png';
      case 'tarik_tunai': return 'assets/image/icon_tarik_tunai.png';
      case 'ppob_pulsa': return 'assets/image/icon_telepon.png';
      case 'ppob_data': return 'assets/image/icon_data.png';
      case 'ppob_listrik': return 'assets/image/listrik_icon.png';
      case 'ppob_pdam': return 'assets/image/pdam_icon.png';
      case 'ppob_bpjs': return 'assets/image/icon_bpjs.png';
      case 'ppob_game': return 'assets/image/game_icon.png';
      default: return 'assets/image/icon_ezpay.png';
    }
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
        // tetap di halaman ini
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const PesanMasukPage()));
        break;
      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ProfilPage()));
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
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
            ),
          ),

          SafeArea(
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
                            'Riwayat Transaksi',
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

                const SizedBox(height: 8),

                // ===== Saldo Card (dari API MySQL) =====
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/image/ezpay_icon.png',
                        height: 42,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Saldo saat ini',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : Text(
                              formatSaldoIdr(_balance),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ===== Daftar Transaksi (dari API MySQL) =====
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _transactions.isEmpty
                          ? const Center(
                              child: Text(
                                'Belum ada riwayat transaksi',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadData,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _transactions.length,
                                itemBuilder: (context, index) {
                                  final tx = _transactions[index];
                                  final type = tx['type'] as String?;
                                  final amount = (tx['amount'] is num)
                                      ? (tx['amount'] as num).toInt()
                                      : int.tryParse('${tx['amount']}') ?? 0;
                                  final isCredit = type == 'topup';
                                  final nominal = isCredit
                                      ? '+${formatSaldoIdr(amount)}'
                                      : '-${formatSaldoIdr(amount)}';
                                  final date = tx['created_at'] as String? ?? '';
                                  final recipientName =
                                      tx['recipient_name'] as String? ??
                                          tx['description'] as String? ??
                                          '';
                                  final code =
                                      tx['transaction_code'] as String? ?? '';

                                  return transaksiItem(
                                    context,
                                    icon: _getTransactionIcon(type),
                                    nama: recipientName,
                                    subtitle: code,
                                    tanggal: date.length >= 10
                                        ? date.substring(0, 10)
                                        : date,
                                    kategori: _getTransactionLabel(type),
                                    nominal: nominal,
                                  );
                                },
                              ),
                            ),
                ),
              ],
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
              isActive: true,
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
              isActive: false,
              onTap: () => _onNavTapped(3),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Widget Transaksi Item =====
  Widget transaksiItem(
    BuildContext context, {
    required String icon,
    required String nama,
    required String subtitle,
    required String tanggal,
    required String kategori,
    required String nominal,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icon, height: 40, width: 40, fit: BoxFit.contain),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(kategori,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black54,
                      fontSize: 12,
                    )),
                Text(nama,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    )),
                Text(subtitle,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: Colors.black87,
                    )),
                Text(tanggal,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.black54,
                    )),
              ],
            ),
          ),
          Text(
            nominal,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: nominal.startsWith('+')
                  ? Colors.green
                  : Colors.redAccent,
            ),
          ),
        ],
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
