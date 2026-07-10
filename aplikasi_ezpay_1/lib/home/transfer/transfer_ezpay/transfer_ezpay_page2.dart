import 'package:flutter/material.dart';
import '../transfer_ui.dart';
import 'transfer_ezpay_page3.dart';

class TransferEzPayPage2 extends StatelessWidget {
  final String akun;

  const TransferEzPayPage2({super.key, required this.akun});

  @override
  Widget build(BuildContext context) {
    // Nama penerima akan hardcoded untuk demo, di real app bisa lookup dari API
    const namaPenerima = 'Roberto Carlos';
    const platform = 'EZ Pay';

    return TransferUi.ezPayScaffold(
      context,
      title: 'EZ Pay',
      bodyChildren: [
        TransferUi.ezPayCard(
          bodyChildren: [
            const Text(
              'Masukkan Nomor Akun EZ Pay',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              readOnly: true,
              controller: TextEditingController(text: akun),
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
              decoration: TransferUi.inputDecoration(),
            ),
            const SizedBox(height: 22),
            const Text(
              'Konfirmasi Penerima',
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
                        const Text(
                          namaPenerima,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '$platform - $akun',
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransferEzPayPage3(
                      recipientPhone: akun,
                      recipientName: namaPenerima,
                    ),
                  ),
                );
              },
              style: TransferUi.primaryElevated(),
              child: const Text('Konfirmasi'),
            ),
          ],
        ),
      ],
    );
  }
}
