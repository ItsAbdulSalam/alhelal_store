import 'package:first_store/screens/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'auth_widgets.dart';
import '../../bloc/Auth/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // ── BLoC: Dispatch Login Event ──────────────────────────
  void _handleLogin() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    // السطر الوحيد المسؤول عن إرسال الطلب للسحابة
    context.read<AuthBloc>().add(
      LoginRequested(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      ),
    );
  }

  void _showMessage(String msg, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        ),
        backgroundColor: isSuccess
            ? const Color(0xFF2D7D46)
            : const Color(0xFF9B3232),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Validators ───────────────────────────────────────────
  String? _validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) return 'البريد الإلكتروني مطلوب';
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(val.trim())) {
      return 'بريد إلكتروني غير صحيح';
    }
    return null;
  }

  String? _validatePassword(String? val) {
    if (val == null || val.isEmpty) return 'كلمة المرور مطلوبة';
    if (val.length < 6) return '6 أحرف على الأقل';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AuthColors.bg,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // الشرط الصارم: لن يتم الانتقال إلا إذا أكدت Firebase الحالة Authenticated
          if (state is Authenticated) {
            _showMessage('أهلاً بك مجدداً في ALHELAL PRIME', isSuccess: true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainWrapper()),
            );
          } else if (state is AuthError) {
            // سيتم عرض رسالة الخطأ القادمة من Firebase هنا
            _showMessage(state.message);
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(24, 20, 24, bottom + 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthBackButton(),
                      const Gap(36),
                      const AuthHeader(
                        title: 'مرحباً بعودتك',
                        subtitle: 'سجّل دخولك للوصول إلى عروضنا الحصرية',
                      ),
                      const Gap(40),
                      AuthField(
                        controller: _emailController,
                        label: 'البريد الإلكتروني',
                        hint: 'example@mail.com',
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_passwordFocus),
                        validator: _validateEmail,
                      ),
                      const Gap(18),
                      AuthField(
                        controller: _passwordController,
                        label: 'كلمة المرور',
                        hint: '••••••••',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        isVisible: _isPasswordVisible,
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.done,
                        onToggleVisibility: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible,
                        ),
                        onFieldSubmitted: (_) => _handleLogin(),
                        validator: _validatePassword,
                      ),
                      const Gap(14),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: navigate to forgot password
                          },
                          child: const Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                              color: AuthColors.gold,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const Gap(36),
                      AuthPrimaryButton(
                        label: 'تسجيل الدخول',
                        isLoading: state is AuthLoading,
                        onTap: _handleLogin,
                      ),
                      const Gap(28),
                      const AuthDivider(),
                      const Gap(28),
                      AuthSocialButton(
                        label: 'المتابعة بحساب Google',
                        icon: _GoogleIcon(),
                        onTap: () {
                          // TODO: Google Sign-In
                        },
                      ),
                      const Gap(40),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: AuthColors.textSecondary,
                              fontSize: 13,
                            ),
                            children: [
                              const TextSpan(text: 'ليس لديك حساب؟  '),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Text(
                                    'إنشاء حساب',
                                    style: TextStyle(
                                      color: AuthColors.gold,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Google Icon Widgets (بقية الكود) ──────────────────────
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  const _GooglePainter();
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;
    final paints = [
      Paint()..color = const Color(0xFF4285F4),
      Paint()..color = const Color(0xFF34A853),
      Paint()..color = const Color(0xFFFBBC05),
      Paint()..color = const Color(0xFFEA4335),
    ];
    for (int i = 0; i < 4; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        (i * 1.5708) - 0.3927,
        1.5708,
        false,
        paints[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
