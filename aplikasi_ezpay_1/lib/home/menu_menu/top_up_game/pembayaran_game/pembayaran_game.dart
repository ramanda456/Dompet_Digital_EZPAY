import 'package:flutter/material.dart';

class PembayaranMobileLegendPage extends StatefulWidget {
  final String idGame;
  final String paketDiamond; // Bisa Diamond, VP, Crystal, Shard, dll

  const PembayaranMobileLegendPage({
    super.key,
    required this.idGame,
    required this.paketDiamond,
  });

  @override
  State<PembayaranMobileLegendPage> createState() =>
      _PembayaranMobileLegendPageState();
}

class _PembayaranMobileLegendPageState
    extends State<PembayaranMobileLegendPage> {
  final List<String> _pin = ['', '', '', ''];
  bool _isSuccess = false;

  void _onNumberTap(String number) {
    for (int i = 0; i < _pin.length; i++) {
      if (_pin[i].isEmpty) {
        setState(() => _pin[i] = number);
        break;
      }
    }
  }

  void _onBackspace() {
    for (int i = _pin.length - 1; i >= 0; i--) {
      if (_pin[i].isNotEmpty) {
        setState(() => _pin[i] = '');
        break;
      }
    }
  }

  void _onConfirm() {
    if (_pin.contains('')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan PIN lengkap terlebih dahulu")),
      );
      return;
    }
    setState(() {
      _isSuccess = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _isSuccess
            ? _buildSuccessScreen(size)
            : _buildPinInputScreen(size),
      ),
    );
  }

  // =================== 1️⃣ MASUKKAN PIN ===================
  Widget _buildPinInputScreen(Size size) {
    return Column(
      children: [
        // Header gradient
        Container(
          width: double.infinity,
          height: size.height * 0.35,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      "Masukkan PIN Anda",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            _pin[index],
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: SizedBox(
                      width: 180,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: _onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2962FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Konfirmasi",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Keypad area
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var row in [
                  ['1', '2', '3'],
                  ['4', '5', '6'],
                  ['7', '8', '9'],
                  ['<', '0', '⌫'],
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: row.map((key) {
                        return _buildKey(key);
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKey(String value) {
    return GestureDetector(
      onTap: () {
        if (value == '⌫') {
          _onBackspace();
        } else if (value != '<') {
          _onNumberTap(value);
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)
          ],
        ),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  // =================== 2️⃣ TRANSAKSI BERHASIL ===================
  Widget _buildSuccessScreen(Size size) {
    return Container(
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
            // Header success
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Pembayaran Top Up Game",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body success
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      "Transaksi Berhasil",
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.check_circle,
                        color: Color(0xFF4CAF50), size: 48),
                    const SizedBox(height: 16),
                    _buildTransactionDetails(),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2962FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Selesai",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading:
              const Icon(Icons.videogame_asset, color: Colors.green, size: 40),
          title: const Text("Pratama"),
          subtitle: Text("Top Up Game | ${widget.idGame}"),
        ),
        const Divider(),
        Text("ID Transaksi: TRF${DateTime.now().millisecondsSinceEpoch}"),
        const Text("Referensi: -"),
        Text(
            "Tanggal: ${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}"),
        const SizedBox(height: 12),
        Text("Paket Top Up: ${widget.paketDiamond}"),
        const Text("Biaya Admin: Rp1.000"),
        const Text("Total: Rp131.000"),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
  }
}
