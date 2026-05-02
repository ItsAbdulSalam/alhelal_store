part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {} // الحالة البدائية
class AuthLoading extends AuthState {} // جاري التحميل (دائرة تدور)
class Authenticated extends AuthState {} // تم تسجيل الدخول بنجاح
class Unauthenticated extends AuthState {} // لم يسجل الدخول
class AuthError extends AuthState { // حدث خطأ
  final String message;
  AuthError(this.message);
}