import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../transfer_ui.dart';
import 'transfer_ezpay_page5.dart';
import '../../../../services/api_service.dart';

class TransferEzPayPage4 extends StatefulWidget {
  final String recipientPhone;
  final String recipientName;
  final double amount;

  const TransferEzPayPage4({
    super.key,
    required this.recipientPhone,
    required this.recipientName,
    required this.amount,
  });

  @override
  State<TransferEzPayPage4> createState() => _TransferEzPayPage4State();
}

class _TransferEzPayPage4State extends State<TransferEzPayPage4> {
  final List<String> _pin = [];
  bool _isSubmitting = false;

  void _add(String d) {
    if (_pin.length < 6) setState(() => _pin.add(d));
  }

  void _del() {
    if (_pin.isNotEmpty) setState(() => _pin.removeLast());
  }

  Widget _boxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 42,
          height: 52,
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
          child: Center(
            child: Text(
              index < _pin.length ? '•' : '',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  children: row.map((k) {
                    return InkWell(
                      onTap: () {
                        if (k == '⌫') {
                          _del();
                        } else if (k == 'hide') {
                          FocusScope.of(context).unfocus();
                        } else {
                          _add(k);
                        }
                      },
                      child: SizedBox(
                        width: 72,
                        height: 52,
                        child: Center(
                          child: k == '⌫'
                              ? const Icon(Icons.backspace_outlined,
                                  size: 26, color: Colors.black54)
                              : k == 'hide'
                                  ? const Icon(Icons.keyboard_hide_rounded,
                                      size: 26, color: Colors.black54)
                                  : Text(
                                      k,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
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
      final result = await ApiService.instance.transferEzpay(
        recipientPhone: widget.recipientPhone,
        amount: widget.amount,
        pin: pinStr,
      );

      if (kDebugMode) debugPrint('Transfer EZPay result: $result');

      if (!mounted) return;

      if (result['success'] == true) {
        final txData = result['data'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TransferEzPayPage5(
              recipientName: widget.recipientName,
              recipientPhone: widget.recipientPhone,
              amount: widget.amount,
              transactionCode: txData?['transaction_code'] ?? '-',
              date: txData?['created_at'] ?? '-',
              adminFee: (txData?['admin_fee'] is num)
                  ? (txData['admin_fee'] as num).toDouble()
                  : 0,
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
        _boxes(),
        const SizedBox(height: 28),
        SizedBox(
          width: w * 0.65,
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
      keypad: _pad(),
    );
  }
}
