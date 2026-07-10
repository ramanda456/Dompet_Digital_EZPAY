import 'package:flutter/material.dart';
import '../../../../home/home_screen.dart';
import '../isi_saldo_lewat_bank_bri/isi_saldo_lewat_bank_bri_page2.dart';

class IsiSaldoLewatBankBriPage1 extends StatefulWidget {
  const IsiSaldoLewatBankBriPage1({super.key});

  @override
  State<IsiSaldoLewatBankBriPage1> createState() => _IsiSaldoLewatBankBriPage1State();
}

class _IsiSaldoLewatBankBriPage1State extends State<IsiSaldoLewatBankBriPage1> {
  bool isMobileBanking = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bank BRI',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // --- Header Logo Bank BRI ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/image/icon_bri.png',
                      width: 60,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Bank BRI",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Tab Menu ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tabButton("Mobile Banking", isMobileBanking, () {
                    setState(() => isMobileBanking = true);
                  }),
                  _tabButton("ATM", !isMobileBanking, () {
                    setState(() => isMobileBanking = false);
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // --- Kartu Detail Isi Saldo ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/image/icon_bri.png', width: 40),
                        const SizedBox(width: 10),
                        const Text(
                          "Bank BRI",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Nomor Virtual Account",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "081234567890",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IsiSaldoLewatBankBriPage2(),
                              ),
                            );

                            // TODO: Fungsi salin ke clipboard
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Nomor Virtual Account disalin"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blueAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Salin",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, thickness: 1),
                    const Text(
                      "Cara Isi Saldo EZ Pay :",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "1. Login Aplikasi Brimo Anda\n"
                      "2. Pilih Menu Top up\n"
                      "3. Pilih Menu Top up e-Wallet\n"
                      "4. Pilih Tambah Penerima Baru\n"
                      "5. Pilih i.saku\n"
                      "6. Masukkan Nomor HP yang terdaftar EZ Pay 081234567890\n"
                      "7. Pilih nilai Top up\n"
                      "8. Ikuti instruksi untuk menyelesaikan transaksi\n"
                      "9. Biaya isi saldo Rp 1.000,-",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- Tombol Kembali ke Beranda ---
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CA5EE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    "KEMBALI KE BERANDA",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white,
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

  // --- Tab Button Reusable ---
  Widget _tabButton(String text, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: isActive ? Colors.black : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
