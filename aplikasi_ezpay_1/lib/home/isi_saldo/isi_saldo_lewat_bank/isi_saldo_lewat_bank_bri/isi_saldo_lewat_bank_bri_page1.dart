import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../services/api_service.dart';
import '../isi_saldo_lewat_bank_bri/isi_saldo_lewat_bank_bri_page2.dart';

class IsiSaldoLewatBankBriPage1 extends StatefulWidget {
  const IsiSaldoLewatBankBriPage1({super.key});

  @override
  State<IsiSaldoLewatBankBriPage1> createState() => _IsiSaldoLewatBankBriPage1State();
}

class _IsiSaldoLewatBankBriPage1State extends State<IsiSaldoLewatBankBriPage1> {
  final TextEditingController _amountController = TextEditingController();
  String? _selectedNominal;
  bool _isLoading = false;

  final List<String> _quickNominals = [
    '20.000',
    '50.000',
    '100.000',
    '200.000',
    '500.000',
    '1.000.000'
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _launchMidtrans(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw 'Tidak dapat membuka browser: $e';
    }
  }

  Future<void> _submit() async {
    // Bersihkan format titik untuk konversi ke angka
    final cleanAmountStr = _amountController.text
        .replaceAll('Rp', '')
        .replaceAll('.', '')
        .trim();
    
    final double? amount = double.tryParse(cleanAmountStr);
    
    if (amount == null || amount < 10000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimal Isi Saldo adalah Rp 10.000'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final res = await ApiService.instance.topUp(amount: amount);
      if (kDebugMode) debugPrint('TopUp response: $res');

      if (!mounted) return;

      if (res['success'] == true && res['data']?['redirect_url'] != null) {
        final redirectUrl = res['data']['redirect_url'] as String;
        final transactionCode = res['data']['transaction_code'] as String? ?? '-';
        final totalPay = (res['data']['total'] is num) 
            ? (res['data']['total'] as num).toDouble() 
            : amount;

        // Buka portal pembayaran Midtrans
        await _launchMidtrans(redirectUrl);

        if (!mounted) return;

        // Navigasi ke halaman petunjuk/status pembayaran
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IsiSaldoLewatBankBriPage2(
              amount: amount,
              transactionCode: transactionCode,
              redirectUrl: redirectUrl,
              total: totalPay,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'] ?? 'Gagal menginisiasi pembayaran'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onQuickSelect(String val) {
    setState(() {
      _selectedNominal = val;
      _amountController.text = val;
    });
  }

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
          'Isi Saldo (Midtrans)',
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
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header Logo Bank BRI
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
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
                        "Pembayaran BRI & VA Instan",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Form Input Nominal
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Masukkan Nominal Isi Saldo",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          prefixText: 'Rp ',
                          prefixStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          hintText: '0',
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) {
                          if (_selectedNominal != val) {
                            setState(() {
                              _selectedNominal = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 14),

                      // Grid Quick Select
                      const Text(
                        "Pilih Nominal Instan",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _quickNominals.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final value = _quickNominals[index];
                          final isSelected = _selectedNominal == value;
                          return GestureDetector(
                            onTap: () => _onQuickSelect(value),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
                                ),
                              ),
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : const Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 18),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Minimum Isi Saldo adalah Rp 10.000. Metode transfer bank dan e-wallet akan tersedia di gerbang pembayaran Midtrans.",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),

                // Tombol Bayar Sekarang
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 4,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "LANJUTKAN PEMBAYARAN",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.1,
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
