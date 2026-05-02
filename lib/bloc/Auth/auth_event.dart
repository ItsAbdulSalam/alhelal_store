part of 'auth_bloc.dart';

abstract class AuthEvent {}

// 1. حدث تسجيل الدخول
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

// 2. حدث تسجيل مستخدم جديد (تم تحديثه لإضافة البيانات الشخصية)
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;    // الاسم الكامل للمستخدم
  final String phoneNumber; // رقم الهاتف

  SignUpRequested({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
  });
}

// 3. حدث تسجيل الخروج
class LogoutRequested extends AuthEvent {}