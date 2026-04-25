import 'package:first_store/screens/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'auth_widgets.dart';

// ═══════════════════════════════════════════════════════════
//  LoginScreen — BLoC-ready structure
//
//  BLoC integration guide:
//  1. Replace Future.delayed with:
//     context.read<AuthBloc>().add(LoginRequested(email, password))
//  2. Wrap body with BlocConsumer<AuthBloc, AuthState>
//  3. Listen for AuthSuccess → navigate, AuthFailure → show error
// ═══════════════════════════════════════════════════════════

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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // ── BLoC: replace this with bloc event dispatch ──────────
  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: context.read<AuthBloc>().add(LoginRequested(
    //   email: _emailController.text.trim(),
    //   password: _passwordController.text,
    // ));
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainWrapper()),
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
      body: GestureDetector(
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
                  // ── Nav row ──────────────────────────────
                  const AuthBackButton(),

                  const Gap(36),

                  // ── Header ───────────────────────────────
                  const AuthHeader(
                    title: 'مرحباً بعودتك',
                    subtitle: 'سجّل دخولك للوصول إلى عروضنا الحصرية',
                  ),

                  const Gap(40),

                  // ── Email ────────────────────────────────
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

                  // ── Password ─────────────────────────────
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

                  // ── Forgot password ───────────────────────
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

                  // ── Login button ──────────────────────────
                  AuthPrimaryButton(
                    label: 'تسجيل الدخول',
                    isLoading: _isLoading,
                    onTap: _handleLogin,
                  ),

                  const Gap(28),

                  // ── Divider ───────────────────────────────
                  const AuthDivider(),

                  const Gap(28),

                  // ── Google button ─────────────────────────
                  AuthSocialButton(
                    label: 'المتابعة بحساب Google',
                    icon: _GoogleIcon(),
                    onTap: () {
                      // TODO: Google Sign-In
                    },
                  ),

                  const Gap(40),

                  // ── Register link ─────────────────────────
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
      ),
    );
  }
}

// ── Google Icon (SVG-like, no package needed) ──────────────
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

    // Simplified G — 4 arcs in Google colors
    final paints = [
      Paint()..color = const Color(0xFF4285F4), // Blue
      Paint()..color = const Color(0xFF34A853), // Green
      Paint()..color = const Color(0xFFFBBC05), // Yellow
      Paint()..color = const Color(0xFFEA4335), // Red
    ];

    // Draw colored quadrant circles
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
