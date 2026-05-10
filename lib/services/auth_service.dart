import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // ← للـ debugPrint

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── تسجيل مستخدم جديد ────────────────────────────────────
  Future<User?> signUp(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // ✅ debugPrint بدل print — لا يعمل في release mode
      debugPrint('خطأ في التسجيل: ${e.message}');
      rethrow;
    }
  }

  // ── تسجيل الدخول ─────────────────────────────────────────
  Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // ✅ debugPrint بدل print
      debugPrint('خطأ في الدخول: ${e.message}');
      return null;
    }
  }

  // ── تسجيل الخروج ─────────────────────────────────────────
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ── المستخدم الحالي ──────────────────────────────────────
  User? get currentUser => _auth.currentUser;

  // ── Stream لحالة تسجيل الدخول ────────────────────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}