import 'package:first_store/bloc/Auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'auth_widgets.dart';
// المسار المحدث بناءً على الصورة

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

  void _handleRegister() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedTerms) {
      _showMessage('يرجى الموافقة على الشروط والأحكام');
      return;
    }

    // إرسال الحدث إلى البلوك باستخدام البيانات من الـ controllers
    context.read<AuthBloc>().add(
      SignUpRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _nameController.text.trim(), // تأكد من وجود الـ Controller
        phoneNumber: _phoneController.text
            .trim(), // تأكد من وجود الـ Controller
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

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AuthColors.bg,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            _showMessage('تم إنشاء الحساب بنجاح', isSuccess: true);
            // بمجرد النجاح يمكنك توجيه المستخدم للشاشة الرئيسية:
            // Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
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
                        title: 'إنشاء حساب',
                        subtitle: 'انضم لآلاف العملاء في ALHELAL PRIME',
                      ),
                      const Gap(36),

                      // Full name
                      AuthField(
                        controller: _nameController,
                        label: 'الاسم الكامل',
                        hint: 'محمد أحمد',
                        icon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_emailFocus),
                        validator: (val) =>
                            (val == null || val.isEmpty) ? 'الاسم مطلوب' : null,
                      ),
                      const Gap(16),

                      // Email
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
                        validator: (val) => (val == null || !val.contains('@'))
                            ? 'بريد غير صحيح'
                            : null,
                      ),
                      const Gap(16),

                      // Phone
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
                        validator: (val) => (val == null || val.isEmpty)
                            ? 'رقم الهاتف مطلوب'
                            : null,
                      ),
                      const Gap(16),

                      // Password
                      AuthField(
                        controller: _passwordController,
                        label: 'كلمة المرور',
                        hint: '8 أحرف على الأقل',
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
                        validator: (val) => (val == null || val.length < 8)
                            ? '8 أحرف على الأقل'
                            : null,
                      ),
                      const Gap(10),

                      _PasswordStrength(controller: _passwordController),
                      const Gap(16),

                      // Confirm password
                      AuthField(
                        controller: _confirmController,
                        label: 'تأكيد كلمة المرور',
                        hint: '••••••••',
                        icon: Icons.lock_reset_rounded,
                        isPassword: true,
                        isVisible: _isConfirmVisible,
                        focusNode: _confirmFocus,
                        textInputAction: TextInputAction.done,
                        onToggleVisibility: () => setState(
                          () => _isConfirmVisible = !_isConfirmVisible,
                        ),
                        onFieldSubmitted: (_) => _handleRegister(),
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return 'تأكيد كلمة المرور مطلوب';
                          if (val != _passwordController.text)
                            return 'كلمتا المرور غير متطابقتين';
                          return null;
                        },
                      ),
                      const Gap(24),

                      _TermsRow(
                        accepted: _acceptedTerms,
                        onTap: () =>
                            setState(() => _acceptedTerms = !_acceptedTerms),
                      ),
                      const Gap(32),

                      // Register button
                      AuthPrimaryButton(
                        label: 'إنشاء الحساب',
                        isLoading: state is AuthLoading,
                        onTap: _handleRegister,
                      ),
                      const Gap(32),

                      // Login link
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                color: AuthColors.textSecondary,
                                fontSize: 13,
                              ),
                              children: [
                                TextSpan(text: 'لديك حساب؟  '),
                                TextSpan(
                                  text: 'تسجيل الدخول',
                                  style: TextStyle(
                                    color: AuthColors.gold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
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

// ══════════════════════════════════════════════════════════
//  Helper Widgets
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

  @override
  Widget build(BuildContext context) {
    final pass = widget.controller.text;
    if (pass.isEmpty) return const SizedBox.shrink();
    int score = 0;
    if (pass.length >= 8) score++;
    if (pass.contains(RegExp(r'[A-Z]'))) score++;
    if (pass.contains(RegExp(r'[0-9]'))) score++;

    return Row(
      children: List.generate(
        4,
        (i) => Expanded(
          child: Container(
            height: 3,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: i < score ? Colors.green : Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}

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
        children: [
          Icon(
            accepted ? Icons.check_box : Icons.check_box_outline_blank,
            color: AuthColors.gold,
          ),
          const Gap(10),
          const Expanded(
            child: Text(
              'أوافق على شروط الاستخدام وسياسة الخصوصية',
              style: TextStyle(color: AuthColors.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
