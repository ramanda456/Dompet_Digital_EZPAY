import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../transfer_ui.dart';
import 'transfer_e_wallet_dana_page5.dart';
import '../../../../services/api_service.dart';

class TransferEWalletDanaPage4 extends StatefulWidget {
  final String nomorHp;
  final String nama;
  final double amount;

  const TransferEWalletDanaPage4({
    super.key,
    required this.nomorHp,
    required this.nama,
    required this.amount,
  });

  @override
  State<TransferEWalletDanaPage4> createState() =>
      _TransferEWalletDanaPage4State();
}

class _TransferEWalletDanaPage4State extends State<TransferEWalletDanaPage4> {
  String _pin = '';
  bool _isSubmitting = false;

  void addDigit(String d) {
    if (_pin.length < 6) setState(() => _pin += d);
  }

  void removeDigit() {
    if (_pin.isNotEmpty) setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Widget _boxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final filled = index < _pin.length;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 42,
          height: 52,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            filled ? '●' : '',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        );
      }),
    );
  }

  Widget _pad() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final row in [
              ['1', '2', '3'],
              ['4', '5', '6'],
              ['7', '8', '9'],
              ['hide', '0', '⌫'],
            ])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: row.map((key) {
                    return InkWell(
                      onTap: () {
                        if (key == '⌫') {
                          removeDigit();
                        } else if (key == 'hide') {
                          FocusScope.of(context).unfocus();
                        } else {
                          addDigit(key);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 76,
                        height: 54,
                        child: Center(
                          child: key == '⌫'
                              ? const Icon(Icons.backspace_outlined,
                                  size: 26, color: Colors.black54)
                              : key == 'hide'
                                  ? const Icon(Icons.keyboard_hide_rounded,
                                      size: 26, color: Colors.black54)
                                  : Text(
                                      key,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_pin.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan PIN 6 digit')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final result = await ApiService.instance.transferEwallet(
        ewalletName: 'DANA',
        accountNumber: widget.nomorHp,
        accountHolderName: widget.nama,
        amount: widget.amount,
        pin: _pin,
      );

      if (kDebugMode) debugPrint('Transfer DANA result: $result');

      if (!mounted) return;

      if (result['success'] == true) {
        final txData = result['data'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TransferEWalletDanaPage5(
              nomorHp: widget.nomorHp,
              nama: widget.nama,
              amount: widget.amount,
              transactionCode: txData?['transaction_code'] ?? '-',
              date: txData?['created_at'] ?? '-',
              adminFee: (txData?['admin_fee'] is num)
                  ? (txData['admin_fee'] as num).toDouble()
                  : 1000,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Transfer gagal'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _pin = '');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return TransferUi.pinScaffold(
      context,
      pinArea: [
        const SizedBox(height: 8),
        _boxes(),
        const SizedBox(height: 28),
        SizedBox(
          width: w * 0.72,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: TransferUi.primaryButton,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade400,
              disabledForegroundColor: Colors.white70,
              elevation: 0,
              minimumSize: Size(w * 0.72, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Konfirmasi'),
          ),
        ),
      ],
      keypad: _pad(),
    );
  }
}
