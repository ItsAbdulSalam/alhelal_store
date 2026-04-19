import 'dart:ui';
import 'package:first_store/screens/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../home.dart'; // تأكد من مسار صفحة الهوم لديك

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // خلفية سوداء لتناسب الهوية الملكية
      body: Stack(
        children: [
          // 1. خلفية بلمسة ضوئية برتقالية خفيفة
          Positioned(
            top: -100,
            right: -100,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: Colors.orange.withOpacity(0.1),
            ),
          ),

          // 2. المحتوى الأساسي
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(40),
                    // زر العودة بتصميم أنيق
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Gap(40),

                    // العنوان
                    const Text(
                      "تسجيل الدخول ✨",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      "استمتع بتجربة تسوق فريدة مع ALHELAL PRIME",
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    const Gap(50),

                    // حقل البريد الإلكتروني
                    _buildCustomField(
                      controller: _emailController,
                      label: "البريد الإلكتروني",
                      hint: "example@mail.com",
                      icon: Icons.email_outlined,
                      validator: (val) =>
                          val!.contains('@') ? null : "يرجى إدخال بريد صحيح",
                    ),
                    const Gap(25),

                    // حقل كلمة المرور
                    _buildCustomField(
                      controller: _passwordController,
                      label: "كلمة المرور",
                      hint: "••••••••",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: !_isPasswordVisible,
                      togglePassword: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                      validator: (val) =>
                          val!.length < 6 ? "كلمة المرور قصيرة جداً" : null,
                    ),

                    const Gap(15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "نسيت كلمة المرور؟",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Gap(40),

                    // زر الدخول المضيء
                    _buildLoginButton(),

                    const Gap(30),
                    // رابط إنشاء حساب
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ليس لديك حساب؟ ",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        GestureDetector(
                          onTap: () {
                            // انتقل لصفحة التسجيل
                          },
                          child: const Text(
                            "إنشاء حساب جديد",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- ودجت بناء الحقول بتصميم Glassmorphism ---
  Widget _buildCustomField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? togglePassword,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const Gap(10),
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              validator: validator,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                prefixIcon: Icon(icon, color: Colors.orange, size: 22),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: togglePassword,
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- زر الدخول المضيء ---
  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // كود تسجيل الدخول الفعلي
            Navigator.pushReplacementNamed(context, '/main');
            // أو إذا كنت تستخدم الـ MaterialPageRoute:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainWrapper()),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: const Text(
          "تسجيل الدخول",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
