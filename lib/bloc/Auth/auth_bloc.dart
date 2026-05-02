import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart'; // الخدمة الجديدة
import '../../models/user_model.dart';      // النموذج الجديد

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService = AuthService();
  final DatabaseService databaseService = DatabaseService(); // تعريف خدمة قاعدة البيانات

  AuthBloc() : super(AuthInitial()) {
    
    // 1. منطق إنشاء حساب جديد (مع حفظ البيانات في Firestore)
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // إنشاء الحساب في Firebase Authentication
        final user = await authService.signUp(event.email, event.password);
        
        if (user != null) {
          // إنشاء كائن المستخدم بالبيانات القادمة من الواجهة
          UserModel newUser = UserModel(
            uid: user.uid,
            email: event.email,
            fullName: event.fullName,
            phoneNumber: event.phoneNumber,
          );

          // حفظ البيانات في Cloud Firestore
          await databaseService.saveUser(newUser);
          
          emit(Authenticated());
        } else {
          emit(AuthError("فشل إنشاء الحساب، حاول مرة أخرى"));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // 2. منطق تسجيل الدخول (مع التحقق الصارم)
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // ننتظر نتيجة تسجيل الدخول من Firebase
        final user = await authService.signIn(event.email, event.password);

        if (user != null) {
          // إذا نجح التحقق، ننتقل للحالة الموثقة
          emit(Authenticated());
        } else {
          // إذا كانت البيانات خاطئة (وعاد null)
          emit(AuthError("البريد الإلكتروني أو كلمة المرور غير صحيحة"));
        }
      } catch (e) {
        // معالجة الأخطاء التقنية
        emit(AuthError("خطأ في تسجيل الدخول: ${e.toString()}"));
      }
    });

    // 3. منطق تسجيل الخروج
    on<LogoutRequested>((event, emit) async {
      try {
        await authService.signOut();
        emit(Unauthenticated());
      } catch (e) {
        emit(AuthError("حدث خطأ أثناء تسجيل الخروج"));
      }
    });
  }
}