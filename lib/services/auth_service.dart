import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // إنشاء نسخة من Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // دالة تسجيل مستخدم جديد
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // هنا يمكنك معالجة الأخطاء (مثلاً: البريد مستخدم مسبقاً)
      print("خطأ في التسجيل: ${e.message}");
      rethrow; 
    }
  }

  // دالة تسجيل الدخول
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("خطأ في الدخول: $e");
      return null;
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
  }
}