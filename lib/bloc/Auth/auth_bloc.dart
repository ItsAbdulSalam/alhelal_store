import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // استخدام Singleton للخدمات لضمان أداء أسرع
  final AuthService authService = AuthService();
  final DatabaseService databaseService = DatabaseService();

  AuthBloc() : super(AuthInitial()) {
    // 1. منطق إنشاء حساب جديد (مع حفظ البيانات في Firestore)
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authService.signUp(event.email, event.password);

        if (user != null) {
          // إنشاء كائن المستخدم مع إضافة حقل createdAt المطلوب
          final UserModel newUser = UserModel(
            uid: user.uid,
            email: event.email,
            fullName: event.fullName,
            phoneNumber: event.phoneNumber,
            createdAt: DateTime.now()
                .toIso8601String(), // ✅ إضافة التاريخ المطلوب
            profilePic: null,
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

    // 2. منطق تسجيل الدخول
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authService.signIn(event.email, event.password);

        if (user != null) {
          emit(Authenticated());
        } else {
          emit(AuthError("البريد الإلكتروني أو كلمة المرور غير صحيحة"));
        }
      } catch (e) {
        emit(AuthError("خطأ في تسجيل الدخول: ${e.toString()}"));
      }
    });

    // 3. ✅ منطق تسجيل الخروج (الحل الجذري للبطء)
    on<LogoutRequested>((event, emit) async {
      try {
        // 🔥 القفز الفوري: نرسل حالة الخروج للواجهة أولاً دون انتظار
        emit(Unauthenticated());

        // ثم نقوم بعملية الخروج الفعلية من Firebase في الخلفية
        await authService.signOut();
      } catch (e) {
        // في حال حدوث خطأ نادر، لا نريد تعطيل خروج المستخدم
        emit(Unauthenticated());
      }
    });
  }
}
