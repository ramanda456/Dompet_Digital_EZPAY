import 'package:flutter/material.dart';

// import halaman lain untuk navigasi navbar bawah
import '../../../home/home_screen.dart';
import '../../../home/nav_menu/riwayat/riwayat_transaksi.dart';
import '../../../home/nav_menu/profil/profil.dart';

class PesanMasukPage extends StatefulWidget {
  const PesanMasukPage({super.key});

  @override
  State<PesanMasukPage> createState() => _PesanMasukPageState();
}

class _PesanMasukPageState extends State<PesanMasukPage> {
  int _selectedIndex = 2;

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
        break;
      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ProfilPage()));
        break;
    }
  }

  final Map<String, List<Map<String, String>>> pesan = {
    'Hari ini': [
      {
        'pesan': 'Saldo Rp.1.500 siap diklaim nih.\nCheck In A+ Reward sekarang!',
        'jam': '09:00'
      },
      {
        'pesan':
            'Udah Bayar BPJS belum? Cek iuran & denda kamu langsung di EZPAY yuk!',
        'jam': '11:00'
      },
      {
        'pesan':
            'Diskon paket data s/d Rp 7RB menunggu diklaim. Serbu promonya yuk!',
        'jam': '14:45'
      },
    ],
    'Kemarin': [
      {
        'pesan':
            'Menangin juga Gaming Gear Razer buatmu player Genshin Impact. Serbu!',
        'jam': '00:00'
      },
      {
        'pesan':
            'MLBB M6 Pass udah siap dibeli lho. Top up di EZPAY.id/games yuk!',
        'jam': '07:00'
      },
      {
        'pesan': 'Rp20.000 telah diterima dari Michael Jackson',
        'jam': '09:30'
      },
    ],
    '09 Sep 2025': [
      {
        'pesan': 'Top up PULSA hemat s/d 30%! Beli di EZPAY buruan serbu!',
        'jam': '20:35'
      },
      {
        'pesan':
            'Diskon paket data s/d Rp 7RB menunggu diklaim. Serbu promonya yuk!',
        'jam': '18:20'
      },
    ],
    '08 Sep 2025': [
      {'pesan': 'Rp 15.000 telah dikirim ke Iker C****las', 'jam': '07:00'},
      {
        'pesan':
            'Kasih pendapatmu tentang transaksi dengan EZPAY disini yuk!',
        'jam': '11:15'
      },
    ],
    '07 Sep 2025': [
      {
        'pesan':
            'Buruan, top up Free Fire di dana.id/games buat dapetin skinnya yuk!',
        'jam': '22:07'
      },
    ],
    '06 Sep 2025': [
      {
        'pesan':
            'Buat beli skin & item eksklusif di MLBB All Stars. Klaim sekarang!',
        'jam': '12:10'
      },
    ],
    '05 Sep 2025': [
      {
        'pesan':
            'Pembayaran layanan pulsa & data Telkomsel berhasil! cek buruan!',
        'jam': '08:17'
      },
      {'pesan': 'Rp70.000 telah diterima dari Ahmad Sahrani', 'jam': '15:15'},
    ],
  };

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
            top: h * 0.18,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Pesan Masuk",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 42),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 14),
                    itemCount: pesan.keys.length,
                    itemBuilder: (context, index) {
                      String tanggal = pesan.keys.elementAt(index);
                      List<Map<String, String>> daftar = pesan[tanggal]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header section (tanggal)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(14, 8, 14, 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F4F8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tanggal,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                          // Daftar pesan
                          ...daftar.map(
                            (item) => Container(
                              margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.notifications_none_rounded,
                                    color: Color(0xFF4CA5EE),
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item['pesan']!,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item['jam']!,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ==== NAVBAR BAWAH (SAMA SEPERTI HOME) ====
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
              isActive: true,
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
}

// ==== KOMPONEN NAVBAR ITEM (PERSIS DENGAN HOME_SCREEN.DART) ====
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
