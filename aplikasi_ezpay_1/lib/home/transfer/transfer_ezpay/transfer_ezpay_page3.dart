import 'package:flutter/material.dart';
import '../transfer_ui.dart';
import 'transfer_ezpay_page4.dart';

class TransferEzPayPage3 extends StatefulWidget {
  final String recipientPhone;
  final String recipientName;

  const TransferEzPayPage3({
    super.key,
    required this.recipientPhone,
    required this.recipientName,
  });

  @override
  State<TransferEzPayPage3> createState() => _TransferEzPayPage3State();
}

class _TransferEzPayPage3State extends State<TransferEzPayPage3> {
  final TextEditingController _nominalController = TextEditingController();

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TransferUi.ezPayScaffold(
      context,
      title: 'EZ Pay',
      bodyChildren: [
        TransferUi.ezPayCard(
          bodyChildren: [
            const Text(
              'Rekening tujuan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFCFE8FF),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFF9EC9F0)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.black54, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recipientName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'EZ Pay - ${widget.recipientPhone}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Masukkan Nominal',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontFamily: 'Poppins'),
              decoration: TransferUi.inputDecoration(hint: 'Rp 0'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final nominal = _nominalController.text.trim();
                if (nominal.isEmpty || (double.tryParse(nominal) ?? 0) <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Masukkan nominal yang valid')),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransferEzPayPage4(
                      recipientPhone: widget.recipientPhone,
                      recipientName: widget.recipientName,
                      amount: double.parse(nominal),
                    ),
                  ),
                );
              },
              style: TransferUi.primaryElevated(),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Transfer'),
                  SizedBox(width: 8),
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
