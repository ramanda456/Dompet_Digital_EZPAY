import 'package:flutter/material.dart';

// Import semua halaman ubah profil
import 'package:aplikasi_ezpay_1/home/nav_menu/profil/pengaturan_profil/ubah_nama/ubah_nama_page1.dart';
import 'package:aplikasi_ezpay_1/home/nav_menu/profil/pengaturan_profil/ubah_no_hp/ubah_no_hp_page1.dart';
import 'package:aplikasi_ezpay_1/home/nav_menu/profil/pengaturan_profil/ubah_email/ubah_email_page1.dart';
import 'package:aplikasi_ezpay_1/home/nav_menu/profil/pengaturan_profil/ubah_sandi/ubah_sandi_page1.dart';
import 'package:aplikasi_ezpay_1/home/nav_menu/profil/pengaturan_profil/ubah_foto_profil/ubah_foto_profil_page1.dart';



class PengaturanProfilPage extends StatefulWidget {
  const PengaturanProfilPage({super.key});

  @override
  State<PengaturanProfilPage> createState() => _PengaturanProfilPageState();
}

class _PengaturanProfilPageState extends State<PengaturanProfilPage> {
  String nama = "Muhammad Rafiq";
  String noHp = "0898765432100";
  String email = "roberto@gmail.com";
  String sandi = "Admin1234#";
  String jenisKelamin = "Laki-laki";

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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Pengaturan Profil",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UbahFotoProfilPage1(),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              AssetImage('assets/image/profile_default.png'),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12, blurRadius: 4, spreadRadius: 1)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("Ubah Nama"),
                          _buildEditableTile(
                            value: nama,
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => UbahNamaPage1()));
                            },
                          ),
                          _buildSectionTitle("Ubah Nomor Handphone"),
                          _buildEditableTile(
                            value: noHp,
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => UbahNoHpPage1()));
                            },
                          ),
                          _buildSectionTitle("Jenis Kelamin"),
                          _buildGenderDropdown(),
                          _buildSectionTitle("Ubah Alamat Email"),
                          _buildEditableTile(
                            value: email,
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => UbahEmailPage1()));
                            },
                          ),
                          _buildSectionTitle("Ubah Sandi"),
                          _buildEditableTile(
                            value: sandi,
                            obscure: true,
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => UbahSandiPage1()));
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Perubahan disimpan!")),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2962FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Simpan",
                                  style: TextStyle(fontSize: 16, color: Colors.white)),
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
        ],
      ),
    );
  }

  // ================= WIDGETS ==================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildEditableTile({
    required String value,
    required VoidCallback onTap,
    bool obscure = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              obscure ? "••••••••" : value,
              style: const TextStyle(fontSize: 14),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: jenisKelamin,
          items: const [
            DropdownMenuItem(value: "Laki-laki", child: Text("Laki-laki")),
            DropdownMenuItem(value: "Perempuan", child: Text("Perempuan")),
          ],
          onChanged: (value) {
            setState(() {
              jenisKelamin = value!;
            });
          },
        ),
      ),
    );
  }
}
