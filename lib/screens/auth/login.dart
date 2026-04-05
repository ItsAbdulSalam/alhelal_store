import 'package:first_store/widgets/CustomTextFiled.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // ألوان التصميم الخاصة بـ Ratmart
  static const Color ratmartRed = Color(0xFFFF5733);
  static const Color ratmartOrange = Color(0xFFFF9F00);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // منطق تسجيل الدخول
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء نقية كالتصميم
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Gap(80), // مسافة علوية مناسبة
                // 1. الشعار (اسم المتجر)
                Image.asset(
                  'assets/images/logo/logo.png', // تأكد من اسم الصورة ومسارها
                  height: 60,
                  fit: BoxFit.contain,
                ),

                const Gap(15),

                // 2. العنوان العلوي (Sub-header)
                const Text(
                  "تسجيل الدخول إلى حسابك",
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),

                const Gap(45), // مسافة كبيرة قبل الحقول
                // 3. حقل البريد الإلكتروني (مطابق تماماً للتصميم)
                CustomTextField(
                  controller: _emailController,
                  labelText: '', // التصميم لا يحتوي على Label فوق الحقل
                  hintText: 'الرجاء ادخال البريد',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.contains('@') ? null : "البريد مطلوب",
                ),

                const Gap(20),

                // 4. حقل كلمة المرور (مطابق للتصميم)
                CustomTextField(
                  controller: _passwordController,
                  labelText: '',
                  hintText: 'الرجاء ادخال كلمة المرور',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true, // سيتفعل منطق إظهار/إخفاء الباسورد تلقائياً
                  validator: (value) =>
                      value!.length < 8 ? "كلمة المرور قصيرة" : null,
                ),

                const Gap(40),

                // 5. زر "إنشاء حساب جديد" البرتقالي (بالأيقونة كالتصميم)
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // انتقال لصفحة التسجيل
                    },
                    icon: const Icon(
                      Icons.person_add_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text(
                      "إنشاء حساب جديد",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ratmartOrange,
                      foregroundColor: Colors.white,
                      elevation: 1, // ظل خفيف جداً
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ), // زوايا دائرية كالتصميم
                      ),
                    ),
                  ),
                ),

                const Gap(20),

                // 6. زر "تسجيل الدخول" الأحمر (بالأيقونة كالتصميم)
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: _handleLogin,
                    icon: const Icon(
                      Icons.login_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ratmartRed,
                      foregroundColor: Colors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
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
  }
}
