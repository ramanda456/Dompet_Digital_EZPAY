import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../services/api_service.dart';
import '../../tarik_tunai_lewat_merchant/tarik_tunai_lewat_merchant_indomaret/tarik_tunai_lewat_merchant_indomaret_page4.dart';

class TarikTunaiLewatMerchantIndomaretPage3 extends StatefulWidget {
  final double amount;

  const TarikTunaiLewatMerchantIndomaretPage3({
    super.key,
    required this.amount,
  });

  @override
  State<TarikTunaiLewatMerchantIndomaretPage3> createState() =>
      _TarikTunaiLewatMerchantIndomaretPage3State();
}

class _TarikTunaiLewatMerchantIndomaretPage3State
    extends State<TarikTunaiLewatMerchantIndomaretPage3> {
  String enteredPin = '';
  bool _isLoading = false;

  void _addDigit(String digit) {
    if (enteredPin.length < 6) {
      setState(() {
        enteredPin += digit;
      });
    }
  }

  void _removeDigit() {
    if (enteredPin.isNotEmpty) {
      setState(() {
        enteredPin = enteredPin.substring(0, enteredPin.length - 1);
      });
    }
  }

  Future<void> _confirmPin() async {
    if (enteredPin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan 6 digit PIN terlebih dahulu")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final res = await ApiService.instance.tarikTunai(
        amount: widget.amount,
        pin: enteredPin,
        merchantCode: 'IND001',
      );

      if (kDebugMode) debugPrint('Tarik tunai response: $res');

      if (!mounted) return;

      if (res['success'] == true) {
        final txData = res['data'];
        final detail = txData?['detail'];
        final withdrawalCode = detail?['withdrawal_code'] as String? ?? '-';
        final transactionCode = txData?['transaction_code'] as String? ?? '-';
        final double adminFee = (txData?['admin_fee'] is num)
            ? (txData['admin_fee'] as num).toDouble()
            : 0.0;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TarikTunaiLewatMerchantIndomaretPage4(
              amount: widget.amount,
              withdrawalCode: withdrawalCode,
              transactionCode: transactionCode,
              adminFee: adminFee,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'] ?? 'Tarik tunai gagal'),
            backgroundColor: Colors.redAccent,
          ),
        );
        setState(() {
          enteredPin = '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Masukkan PIN Anda",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // PIN boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  bool filled = index < enteredPin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 45,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        filled ? "•" : "",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              // Tombol konfirmasi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _isLoading ? null : _confirmPin,
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
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                ),
              ),

              const Spacer(),

              // Numpad
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  children: [
                    _buildNumberRow(['1', '2', '3']),
                    const SizedBox(height: 16),
                    _buildNumberRow(['4', '5', '6']),
                    const SizedBox(height: 16),
                    _buildNumberRow(['7', '8', '9']),
                    const SizedBox(height: 16),
                    _buildNumberRow(['', '0', '<']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((digit) {
        if (digit == '<') {
          return _numButton(
            icon: Icons.backspace_outlined,
            onTap: _removeDigit,
          );
        } else if (digit.isEmpty) {
          return const SizedBox(width: 60);
        } else {
          return _numButton(
            text: digit,
            onTap: () => _addDigit(digit),
          );
        }
      }).toList(),
    );
  }

  Widget _numButton({String? text, IconData? icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: icon != null
            ? Icon(icon, size: 26, color: Colors.black87)
            : Text(
                text!,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
      ),
    );
  }
}
