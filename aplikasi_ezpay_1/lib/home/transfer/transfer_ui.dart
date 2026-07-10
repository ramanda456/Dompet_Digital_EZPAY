import 'package:flutter/material.dart';

/// Transfer flows — green app bar, vertical gradient, white rounded-top sheet.
abstract final class TransferUi {
  static const Color appGreen = Color(0xFF4CAF50);
  static const Color scaffoldBackground = Color(0xFFF5F5F5);
  static const Color borderMuted = Color(0xFFE0E0E0);
  static const Color borderSoft = Color(0xFFE8E8E8);
  static const Color inputFill = Color(0xFFEFEFEF);
  static const Color primaryButton = Color(0xFF42A5F5);

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient ezPayCardHeaderGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF4CAF50)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const TextStyle appBarTitleStyle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 18,
    color: Colors.white,
  );

  static AppBar greenAppBar(
    BuildContext context, {
    required String title,
    bool showTitle = true,
  }) {
    return AppBar(
      backgroundColor: appGreen,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      iconTheme: const IconThemeData(color: Colors.white),
      title: showTitle && title.isNotEmpty
          ? Text(title, style: appBarTitleStyle)
          : null,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.maybePop(context),
      ),
    );
  }

  static const double _gradientBand = 128;
  static const double _sheetOverlap = 44;

  /// Form flow: green app bar + gradient band + optional chip on gradient + white sheet.
  static Widget page(
    BuildContext context, {
    required String title,
    Widget? headerOnGradient,
    required List<Widget> children,
    EdgeInsets sheetPadding = const EdgeInsets.fromLTRB(18, 24, 18, 28),
  }) {
    return Scaffold(
      backgroundColor: scaffoldBackground,
      appBar: greenAppBar(context, title: title),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: _gradientBand,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(gradient: headerGradient),
                  ),
                ),
                if (headerOnGradient != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: headerOnGradient,
                  ),
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -_sheetOverlap),
              child: Material(
                elevation: 10,
                shadowColor: Colors.black26,
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  child: SingleChildScrollView(
                    padding: sheetPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Small white floating card shown on gradient (bank / DANA header).
  static Widget gradientChip({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  static InputDecoration inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: 'Poppins',
        color: Colors.grey.shade600,
      ),
      filled: true,
      fillColor: inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.6),
      ),
    );
  }

  static ButtonStyle primaryElevated() {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryButton,
      foregroundColor: Colors.white,
      elevation: 0,
      minimumSize: const Size(double.infinity, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }

  /// White card — blue→green title strip (EZ Pay).
  static Widget ezPayCard({required List<Widget> bodyChildren}) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            decoration: const BoxDecoration(
              gradient: ezPayCardHeaderGradient,
            ),
            child: const Text(
              'Transfer Ke Sesama EZ Pay',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: bodyChildren,
            ),
          ),
        ],
      ),
    );
  }

  /// EZ Pay: green app bar + gradient + single scroll; [body] is usually [ezPayCard].
  static Widget ezPayScaffold(
    BuildContext context, {
    required String title,
    required List<Widget> bodyChildren,
    EdgeInsets padding = const EdgeInsets.fromLTRB(18, 8, 18, 24),
  }) {
    return Scaffold(
      backgroundColor: scaffoldBackground,
      appBar: greenAppBar(context, title: title),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 100,
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: headerGradient),
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -36),
              child: SingleChildScrollView(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: bodyChildren,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// PIN: green app bar, full-width gradient, white keypad.
  static Widget pinScaffold(
    BuildContext context, {
    required List<Widget> pinArea,
    required Widget keypad,
  }) {
    return Scaffold(
      backgroundColor: scaffoldBackground,
      appBar: greenAppBar(context, title: 'Masukkan PIN Anda'),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(gradient: headerGradient),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: pinArea,
              ),
            ),
          ),
          keypad,
        ],
      ),
    );
  }

  /// Success: green app bar (no title), full gradient, white detail card.
  static Widget successPage(
    BuildContext context, {
    required List<Widget> cardChildren,
  }) {
    return Scaffold(
      backgroundColor: appGreen,
      appBar: greenAppBar(context, title: '', showTitle: false),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: headerGradient),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: cardChildren,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget successHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: appGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 10),
        const Text(
          'Transaksi Berhasil!',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E88E5),
          ),
        ),
      ],
    );
  }

  static Widget successDetailTitleBand() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: appGreen,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
          bottom: Radius.circular(12),
        ),
      ),
      child: const Text(
        'Rincian Transaksi',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    );
  }

  // Legacy names used by list screens
  static BoxDecoration get mainCardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderSoft),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get listRowDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderMuted),
      );

  static BoxDecoration get sectionCardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderSoft),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );
}
