import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Saldo dan profil pengguna di Firestore: `users/{uid}`.
class UserFirestoreService {
  UserFirestoreService._();

  static final UserFirestoreService instance = UserFirestoreService._();

  CollectionReference<Map<String, dynamic>> get _users =>
      FirebaseFirestore.instance.collection('users');

  Stream<DocumentSnapshot<Map<String, dynamic>>> userDocStream(String uid) {
    return _users.doc(uid).snapshots();
  }

  /// Buat dokumen jika belum ada; jika sudah ada, perbarui field yang dikirim.
  Future<void> syncUserProfile(
    User user, {
    String? displayName,
    String? phone,
    String? nik,
    String? gender,
  }) async {
    final ref = _users.doc(user.uid);
    final snap = await ref.get();
    final now = FieldValue.serverTimestamp();

    if (!snap.exists) {
      await ref.set({
        'displayName': displayName ?? user.displayName ?? 'Pengguna',
        'email': user.email ?? '',
        'phone': phone ?? '',
        if (nik != null && nik.isNotEmpty) 'nik': nik,
        if (gender != null && gender.isNotEmpty) 'gender': gender,
        'balance': 0,
        'createdAt': now,
        'updatedAt': now,
      });
    } else {
      final updates = <String, dynamic>{
        'updatedAt': now,
        if (user.email != null) 'email': user.email,
      };
      if (displayName != null && displayName.isNotEmpty) {
        updates['displayName'] = displayName;
      }
      if (phone != null && phone.isNotEmpty) {
        updates['phone'] = phone;
      }
      if (nik != null && nik.isNotEmpty) {
        updates['nik'] = nik;
      }
      if (gender != null && gender.isNotEmpty) {
        updates['gender'] = gender;
      }
      if (updates.length > 1) {
        await ref.update(updates);
      }
    }
  }
}

/// Format saldo untuk tampilan (ribuan dipisah titik).
String formatSaldoIdr(int value) {
  final negative = value < 0;
  final abs = value.abs();
  final raw = abs.toString();
  final out = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) {
      out.write('.');
    }
    out.write(raw[i]);
  }
  final prefix = negative ? '-Rp. ' : 'Rp. ';
  return '$prefix$out';
}
