import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../services/api_service.dart';
import 'top_up_e_wallet_shoppepay_page7.dart';

class TopUpEwalletShoppePayPage6 extends StatefulWidget {
  final String penerimaNama;
  final String penerimaNomor;
  final double amount;
  final double adminFee;

  const TopUpEwalletShoppePayPage6({
    super.key,
    required this.penerimaNama,
    required this.penerimaNomor,
    required this.amount,
    required this.adminFee,
  });

  @override
  State<TopUpEwalletShoppePayPage6> createState() =>
      _TopUpEwalletShoppePayPage6State();
}

class _TopUpEwalletShoppePayPage6State
    extends State<TopUpEwalletShoppePayPage6> {
  final List<String> pin = ["", "", "", "", "", ""];
  int currentIndex = 0;
  bool _isLoading = false;

  void _addDigit(String value) {
    if (currentIndex < 6) {
      setState(() {
        pin[currentIndex] = value;
        currentIndex++;
      });
    }
  }

  void _removeDigit() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        pin[currentIndex] = "";
      });
    }
  }

  Future<void> _confirmPin() async {
    if (pin.contains("")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap masukkan PIN lengkap")),
      );
      return;
    }

    final pinValue = pin.join();
    setState(() => _isLoading = true);

    try {
      final res = await ApiService.instance.transferEwallet(
        ewalletName: 'ShopeePay',
        accountNumber: widget.penerimaNomor,
        accountHolderName: widget.penerimaNama,
        amount: widget.amount,
        pin: pinValue,
      );

      if (kDebugMode) debugPrint('E-wallet transfer response: $res');

      if (!mounted) return;

      if (res['success'] == true) {
        final txData = res['data'];
        final transactionCode = txData?['transaction_code'] ?? '-';
        final date = txData?['created_at'] ?? '-';

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TopUpEwalletShoppePayPage7(
              penerimaNama: widget.penerimaNama,
              penerimaNomor: widget.penerimaNomor,
              amount: widget.amount,
              adminFee: widget.adminFee,
              transactionCode: transactionCode,
              date: date,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'] ?? 'Transfer gagal'),
            backgroundColor: Colors.redAccent,
          ),
        );
        setState(() {
          for (int i = 0; i < 6; i++) {
            pin[i] = "";
          }
          currentIndex = 0;
        });
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

  Widget _buildPinBox(String value) {
    return Container(
      width: 42,
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        value.isEmpty ? "" : "●",
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _addDigit(number),
      child: Container(
        alignment: Alignment.center,
        width: 72,
        height: 52,
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          for (var row in [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"],
            ["", "0", "⌫"]
          ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row.map((value) {
                  if (value == "") {
                    return const SizedBox(width: 72);
                  } else if (value == "⌫") {
                    return GestureDetector(
                      onTap: _removeDigit,
                      child: const SizedBox(
                        width: 72,
                        height: 52,
                        child: Icon(Icons.backspace_outlined, size: 26),
                      ),
                    );
                  } else {
                    return _buildNumberButton(value);
                  }
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50), // Hijau atas
              Color(0xFF2196F3), // Biru bawah
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Masukkan PIN Anda',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // PIN INPUT BOXES
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: pin.map((digit) => _buildPinBox(digit)).toList(),
              ),

              const SizedBox(height: 40),

              // TOMBOL KONFIRMASI
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _confirmPin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F51B5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Konfirmasi",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                ),
              ),

              const Spacer(),

              // NUMPAD
              _buildKeyboard(),
            ],
          ),
        ),
      ),
    );
  }
}
