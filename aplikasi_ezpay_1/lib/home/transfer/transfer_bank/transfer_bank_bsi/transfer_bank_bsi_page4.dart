import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../transfer_ui.dart';
import 'transfer_bank_bsi_page5.dart';
import '../../../../services/api_service.dart';

class TransferBankBSIPage4 extends StatefulWidget {
  final String rekening;
  final String nama;
  final double amount;

  const TransferBankBSIPage4({
    super.key,
    required this.rekening,
    required this.nama,
    required this.amount,
  });

  @override
  State<TransferBankBSIPage4> createState() => _TransferBankBSIPage4State();
}

class _TransferBankBSIPage4State extends State<TransferBankBSIPage4> {
  final List<String> _pin = [];
  bool _isSubmitting = false;

  void _onNumberPress(String number) {
    if (_pin.length < 6) {
      setState(() {
        _pin.add(number);
      });
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin.removeLast();
      });
    }
  }

  Widget _pinBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
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
          child: Center(
            child: Text(
              index < _pin.length ? '●' : '',
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _keypad() {
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
                  children: row.map((value) {
                    return InkWell(
                      onTap: () {
                        if (value == '⌫') {
                          _onDelete();
                        } else if (value == 'hide') {
                          FocusScope.of(context).unfocus();
                        } else {
                          _onNumberPress(value);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 76,
                        height: 54,
                        child: Center(
                          child: value == '⌫'
                              ? const Icon(Icons.backspace_outlined,
                                  size: 26, color: Colors.black54)
                              : value == 'hide'
                                  ? const Icon(Icons.keyboard_hide_rounded,
                                      size: 26, color: Colors.black54)
                                  : Text(
                                      value,
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
    final pinStr = _pin.join();

    try {
      final result = await ApiService.instance.transferBank(
        bankCode: 'BSI',
        bankName: 'Bank Syariah Indonesia',
        accountNumber: widget.rekening,
        accountHolderName: widget.nama,
        amount: widget.amount,
        pin: pinStr,
      );

      if (kDebugMode) debugPrint('Transfer Bank BSI result: $result');

      if (!mounted) return;

      if (result['success'] == true) {
        final txData = result['data'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TransferBankBSIPage5(
              rekening: widget.rekening,
              nama: widget.nama,
              amount: widget.amount,
              transactionCode: txData?['transaction_code'] ?? '-',
              date: txData?['created_at'] ?? '-',
              adminFee: (txData?['admin_fee'] is num)
                  ? (txData['admin_fee'] as num).toDouble()
                  : 2500,
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
        setState(() => _pin.clear());
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
        _pinBoxes(),
        const SizedBox(height: 28),
        SizedBox(
          width: w * 0.72,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submit,
            style: TransferUi.primaryElevated(),
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
      keypad: _keypad(),
    );
  }
}
