import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Service tunggal untuk semua komunikasi ke Laravel REST API.
///
/// Menyimpan Sanctum token di memory setelah login/register,
/// lalu menyertakannya di setiap request yang butuh autentikasi.
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  // ── Base URL ────────────────────────────────────────────
  // Menggunakan Ngrok agar bisa diakses dari device fisik
  // dan Midtrans bisa mengirim webhook callback.
  // ⚠️ URL ini berubah setiap restart Ngrok, update jika perlu.
  static String get _baseUrl {
    return 'https://seducing-outage-epilepsy.ngrok-free.dev/api';
  }

  /// Token Sanctum, disimpan di memory setelah login/register.
  String? _token;

  /// Apakah sudah login (punya token)?
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  /// Set token secara manual (misal saat restore session).
  void setToken(String token) => _token = token;

  /// Hapus token (saat logout).
  void clearToken() => _token = null;

  // ── Headers ─────────────────────────────────────────────
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  // ── Helper: parse response ──────────────────────────────
  Map<String, dynamic> _decode(http.Response res) {
    try {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      return {'success': false, 'message': 'Response tidak valid'};
    }
  }

  // ════════════════════════════════════════════════════════
  //  AUTH
  // ════════════════════════════════════════════════════════

  /// Register user baru ke MySQL.
  Future<Map<String, dynamic>> register({
    required String firebaseUid,
    required String name,
    required String email,
    required String phone,
    required String nik,
    required String gender,
    required String pin,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: _headers,
        body: jsonEncode({
          'firebase_uid': firebaseUid,
          'name': name,
          'email': email,
          'phone': phone,
          'nik': nik,
          'gender': gender,
          'pin': pin,
        }),
      );
      final data = _decode(res);
      if (data['success'] == true && data['data']?['token'] != null) {
        _token = data['data']['token'] as String;
      }
      return data;
    } catch (e) {
      debugPrint('ApiService.register error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server: $e'};
    }
  }

  /// Login ke MySQL via firebase_uid. Juga kirim FCM token.
  Future<Map<String, dynamic>> login({
    required String firebaseUid,
    String? fcmToken,
    String? deviceInfo,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: _headers,
        body: jsonEncode({
          'firebase_uid': firebaseUid,
          if (fcmToken != null) 'fcm_token': fcmToken,
          if (deviceInfo != null) 'device_info': deviceInfo,
        }),
      );
      final data = _decode(res);
      if (data['success'] == true && data['data']?['token'] != null) {
        _token = data['data']['token'] as String;
      }
      return data;
    } catch (e) {
      debugPrint('ApiService.login error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server: $e'};
    }
  }

  /// Logout: hapus Sanctum token di server.
  Future<Map<String, dynamic>> logout() async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: _headers,
      );
      _token = null;
      return _decode(res);
    } catch (e) {
      _token = null;
      return {'success': false, 'message': '$e'};
    }
  }

  // ════════════════════════════════════════════════════════
  //  PROFILE
  // ════════════════════════════════════════════════════════

  /// Ambil profil user dari MySQL.
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: _headers,
      );
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  /// Update profil (name, phone).
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
  }) async {
    try {
      final res = await http.put(
        Uri.parse('$_baseUrl/profile'),
        headers: _headers,
        body: jsonEncode({
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
        }),
      );
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  // ════════════════════════════════════════════════════════
  //  SALDO
  // ════════════════════════════════════════════════════════

  /// Ambil saldo user.
  Future<Map<String, dynamic>> getSaldo() async {
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/saldo'),
        headers: _headers,
      );
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  // ════════════════════════════════════════════════════════
  //  TRANSACTIONS
  // ════════════════════════════════════════════════════════

  /// Ambil daftar riwayat transaksi.
  Future<Map<String, dynamic>> getTransactions({int? limit, int? page}) async {
    try {
      final params = <String, String>{};
      if (limit != null) params['limit'] = '$limit';
      if (page != null) params['page'] = '$page';

      final uri = Uri.parse('$_baseUrl/transactions')
          .replace(queryParameters: params.isEmpty ? null : params);
      final res = await http.get(uri, headers: _headers);
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  /// Detail transaksi berdasarkan kode.
  Future<Map<String, dynamic>> getTransactionDetail(String code) async {
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/transactions/$code'),
        headers: _headers,
      );
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  // ════════════════════════════════════════════════════════
  //  TRANSFER
  // ════════════════════════════════════════════════════════

  /// Transfer EZ Pay (P2P).
  Future<Map<String, dynamic>> transferEzpay({
    required String recipientPhone,
    required double amount,
    required String pin,
    String? note,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/transfer/ezpay'),
        headers: _headers,
        body: jsonEncode({
          'recipient_phone': recipientPhone,
          'amount': amount,
          'pin': pin,
          if (note != null) 'note': note,
        }),
      );
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  /// Transfer ke bank.
  Future<Map<String, dynamic>> transferBank({
    required String bankCode,
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
    required double amount,
    required String pin,
    String? note,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/transfer/bank'),
        headers: _headers,
        body: jsonEncode({
          'bank_code': bankCode,
          'bank_name': bankName,
          'account_number': accountNumber,
          'account_holder_name': accountHolderName,
          'amount': amount,
          'pin': pin,
          if (note != null) 'note': note,
        }),
      );
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  /// Transfer ke e-wallet.
  Future<Map<String, dynamic>> transferEwallet({
    required String ewalletName,
    required String accountNumber,
    required String accountHolderName,
    required double amount,
    required String pin,
    String? note,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/transfer/ewallet'),
        headers: _headers,
        body: jsonEncode({
          'ewallet_name': ewalletName,
          'account_number': accountNumber,
          'account_holder_name': accountHolderName,
          'amount': amount,
          'pin': pin,
          if (note != null) 'note': note,
        }),
      );
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  /// Tarik tunai.
  Future<Map<String, dynamic>> tarikTunai({
    required double amount,
    required String pin,
    required String merchantCode,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/tarik-tunai'),
        headers: _headers,
        body: jsonEncode({
          'amount': amount,
          'pin': pin,
          'merchant_code': merchantCode,
        }),
      );
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  // ════════════════════════════════════════════════════════
  //  PPOB
  // ════════════════════════════════════════════════════════

  /// Ambil kategori PPOB.
  Future<Map<String, dynamic>> ppobCategories() async {
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/ppob/categories'),
        headers: _headers,
      );
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  /// Ambil produk PPOB per kategori.
  Future<Map<String, dynamic>> ppobProducts({String? category}) async {
    try {
      final params = <String, String>{};
      if (category != null) params['category'] = category;

      final uri = Uri.parse('$_baseUrl/ppob/products')
          .replace(queryParameters: params.isEmpty ? null : params);
      final res = await http.get(uri, headers: _headers);
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  /// Beli produk PPOB (pulsa, data, listrik, game, bpjs, pdam).
  Future<Map<String, dynamic>> ppobPurchase({
    required int productId,
    required String customerNumber,
    required String pin,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/ppob/purchase'),
        headers: _headers,
        body: jsonEncode({
          'product_id': productId,
          'customer_number': customerNumber,
          'pin': pin,
        }),
      );
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  // ════════════════════════════════════════════════════════
  //  TOP UP SALDO
  // ════════════════════════════════════════════════════════

  /// Inisiasi top up saldo via Midtrans.
  Future<Map<String, dynamic>> topUp({required double amount}) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/topup'),
        headers: _headers,
        body: jsonEncode({'amount': amount}),
      );
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  // ════════════════════════════════════════════════════════
  //  FCM TOKEN
  // ════════════════════════════════════════════════════════

  /// Simpan/update FCM token ke server.
  Future<Map<String, dynamic>> storeFcmToken({
    required String fcmToken,
    String? deviceInfo,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/fcm-token'),
        headers: _headers,
        body: jsonEncode({
          'fcm_token': fcmToken,
          if (deviceInfo != null) 'device_info': deviceInfo,
        }),
      );
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  // ════════════════════════════════════════════════════════
  //  PIN
  // ════════════════════════════════════════════════════════

  /// Verifikasi PIN user.
  Future<Map<String, dynamic>> verifyPin({required String pin}) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/verify-pin'),
        headers: _headers,
        body: jsonEncode({'pin': pin}),
      );
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  /// Ganti PIN.
  Future<Map<String, dynamic>> changePin({
    required String currentPin,
    required String newPin,
  }) async {
    try {
      final res = await http.put(
        Uri.parse('$_baseUrl/change-pin'),
        headers: _headers,
        body: jsonEncode({
          'current_pin': currentPin,
          'new_pin': newPin,
        }),
      );
      return _decode(res);
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }
}
