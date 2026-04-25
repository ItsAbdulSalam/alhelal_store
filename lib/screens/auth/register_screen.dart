import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'auth_widgets.dart';

// ═══════════════════════════════════════════════════════════
//  RegisterScreen — BLoC-ready structure
//
//  BLoC integration:
//  1. context.read<AuthBloc>().add(RegisterRequested(...))
//  2. BlocConsumer for AuthSuccess / AuthFailure states
// ═══════════════════════════════════════════════════════════

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  // Focus nodes
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmFocus = FocusNode();

  // State
  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;
  bool _isLoading = false;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  // ── BLoC: replace with bloc event ───────────────────────
  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      _showMessage('يرجى الموافقة على الشروط والأحكام');
      return;
    }

    setState(() => _isLoading = true);

    // TODO: context.read<AuthBloc>().add(RegisterRequested(
    //   name: _nameController.text.trim(),
    //   email: _emailController.text.trim(),
    //   phone: _phoneController.text.trim(),
    //   password: _passwordController.text,
    // ));
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _showMessage('تم إنشاء الحساب بنجاح', isSuccess: true);
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
  String? _validateName(String? val) {
    if (val == null || val.trim().isEmpty) return 'الاسم مطلوب';
    if (val.trim().length < 3) return '3 أحرف على الأقل';
    if (val.trim().split(' ').length < 2) return 'يرجى إدخال الاسم الكامل';
    return null;
  }

  String? _validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) return 'البريد الإلكتروني مطلوب';
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(val.trim())) {
      return 'بريد إلكتروني غير صحيح';
    }
    return null;
  }

  String? _validatePhone(String? val) {
    if (val == null || val.trim().isEmpty) return 'رقم الهاتف مطلوب';
    final digits = val.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9 || digits.length > 15) return 'رقم هاتف غير صحيح';
    return null;
  }

  String? _validatePassword(String? val) {
    if (val == null || val.isEmpty) return 'كلمة المرور مطلوبة';
    if (val.length < 8) return '8 أحرف على الأقل';
    if (!val.contains(RegExp(r'[A-Z]'))) return 'يجب أن تحتوي على حرف كبير';
    if (!val.contains(RegExp(r'[0-9]'))) return 'يجب أن تحتوي على رقم';
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
                  // ── Nav ───────────────────────────────────
                  const AuthBackButton(),

                  const Gap(36),

                  // ── Header ────────────────────────────────
                  const AuthHeader(
                    title: 'إنشاء حساب',
                    subtitle: 'انضم لآلاف العملاء في ALHELAL PRIME',
                  ),

                  const Gap(36),

                  // ── Full name ─────────────────────────────
                  AuthField(
                    controller: _nameController,
                    label: 'الاسم الكامل',
                    hint: 'محمد أحمد',
                    icon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_emailFocus),
                    validator: _validateName,
                  ),

                  const Gap(16),

                  // ── Email ──────────────────────────────────
                  AuthField(
                    controller: _emailController,
                    label: 'البريد الإلكتروني',
                    hint: 'example@mail.com',
                    icon: Icons.alternate_email_rounded,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_phoneFocus),
                    validator: _validateEmail,
                  ),

                  const Gap(16),

                  // ── Phone ──────────────────────────────────
                  AuthField(
                    controller: _phoneController,
                    label: 'رقم الهاتف',
                    hint: '+90 5xx xxx xxxx',
                    icon: Icons.phone_outlined,
                    focusNode: _phoneFocus,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_passFocus),
                    validator: _validatePhone,
                  ),

                  const Gap(16),

                  // ── Password ───────────────────────────────
                  AuthField(
                    controller: _passwordController,
                    label: 'كلمة المرور',
                    hint: '8 أحرف، حرف كبير، ورقم',
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    isVisible: _isPasswordVisible,
                    focusNode: _passFocus,
                    textInputAction: TextInputAction.next,
                    onToggleVisibility: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_confirmFocus),
                    validator: _validatePassword,
                  ),

                  const Gap(10),

                  // ── Password strength ──────────────────────
                  _PasswordStrength(controller: _passwordController),

                  const Gap(16),

                  // ── Confirm password ───────────────────────
                  AuthField(
                    controller: _confirmController,
                    label: 'تأكيد كلمة المرور',
                    hint: '••••••••',
                    icon: Icons.lock_reset_rounded,
                    isPassword: true,
                    isVisible: _isConfirmVisible,
                    focusNode: _confirmFocus,
                    textInputAction: TextInputAction.done,
                    onToggleVisibility: () =>
                        setState(() => _isConfirmVisible = !_isConfirmVisible),
                    onFieldSubmitted: (_) => _handleRegister(),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'تأكيد كلمة المرور مطلوب';
                      }
                      if (val != _passwordController.text) {
                        return 'كلمتا المرور غير متطابقتين';
                      }
                      return null;
                    },
                  ),

                  const Gap(24),

                  // ── Terms checkbox ─────────────────────────
                  _TermsRow(
                    accepted: _acceptedTerms,
                    onTap: () =>
                        setState(() => _acceptedTerms = !_acceptedTerms),
                  ),

                  const Gap(32),

                  // ── Register button ────────────────────────
                  AuthPrimaryButton(
                    label: 'إنشاء الحساب',
                    isLoading: _isLoading,
                    onTap: _handleRegister,
                  ),

                  const Gap(32),

                  // ── Login link ─────────────────────────────
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: AuthColors.textSecondary,
                          fontSize: 13,
                        ),
                        children: [
                          const TextSpan(text: 'لديك حساب؟  '),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                'تسجيل الدخول',
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

// ══════════════════════════════════════════════════════════
//  Password Strength Indicator
// ══════════════════════════════════════════════════════════
class _PasswordStrength extends StatefulWidget {
  final TextEditingController controller;
  const _PasswordStrength({required this.controller});

  @override
  State<_PasswordStrength> createState() => _PasswordStrengthState();
}

class _PasswordStrengthState extends State<_PasswordStrength> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  int get _score {
    final p = widget.controller.text;
    int s = 0;
    if (p.length >= 8) s++;
    if (p.contains(RegExp(r'[A-Z]'))) s++;
    if (p.contains(RegExp(r'[0-9]'))) s++;
    if (p.contains(RegExp(r'[!@#\$%^&*]'))) s++;
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final pass = widget.controller.text;
    if (pass.isEmpty) return const SizedBox.shrink();

    final s = _score.clamp(0, 4);
    final labels = ['ضعيفة', 'مقبولة', 'جيدة', 'قوية', 'ممتازة'];
    final colors = [
      AuthColors.error,
      const Color(0xFFD97706),
      const Color(0xFFCA8A04),
      const Color(0xFF16A34A),
      const Color(0xFF15803D),
    ];

    return Row(
      children: [
        // 4 bars
        ...List.generate(4, (i) {
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
              height: 3,
              decoration: BoxDecoration(
                color: i < s ? colors[s] : AuthColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),

        const SizedBox(width: 10),

        // Label
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            labels[s],
            key: ValueKey(s),
            style: TextStyle(
              color: colors[s],
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
//  Terms Row
// ══════════════════════════════════════════════════════════
class _TermsRow extends StatelessWidget {
  final bool accepted;
  final VoidCallback onTap;

  const _TermsRow({required this.accepted, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom checkbox
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: accepted ? AuthColors.gold : Colors.transparent,
              border: Border.all(
                color: accepted ? AuthColors.gold : AuthColors.border,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: accepted
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 13)
                : null,
          ),

          const SizedBox(width: 10),

          // Text
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: AuthColors.textSecondary,
                  fontSize: 12,
                  height: 1.6,
                ),
                children: [
                  TextSpan(text: 'أوافق على '),
                  TextSpan(
                    text: 'شروط الاستخدام',
                    style: TextStyle(
                      color: AuthColors.gold,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: ' وسياسة الخصوصية'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
