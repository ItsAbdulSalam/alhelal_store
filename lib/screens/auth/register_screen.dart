import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // الحفاظ على السواد القاتم والفخم
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                // زر العودة
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
                const Gap(30),

                const Text(
                  "إنشاء حساب جديد ✨",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(10),
                Text(
                  "انضم إلى ALHELAL PRIME وابدأ تجربة تسوق عالمية",
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                const Gap(40),

                // حقل الاسم الكامل
                _buildCustomField(
                  controller: _nameController,
                  label: "الاسم الكامل",
                  hint: "ادخل اسمك الثلاثي",
                  icon: Icons.person_outline_rounded,
                  validator: (val) => val!.isEmpty ? "الاسم مطلوب" : null,
                ),
                const Gap(20),

                // حقل البريد الإلكتروني
                _buildCustomField(
                  controller: _emailController,
                  label: "البريد الإلكتروني",
                  hint: "abdulsalam@gmail.com",
                  icon: Icons.email_outlined,
                  validator: (val) =>
                      val!.contains('@') ? null : "البريد غير صحيح",
                ),
                const Gap(20),

                // حقل كلمة المرور
                _buildCustomField(
                  controller: _passwordController,
                  label: "كلمة المرور",
                  hint: "••••••••",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: !_isPasswordVisible,
                  togglePassword: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                  validator: (val) =>
                      val!.length < 6 ? "كلمة المرور ضعيفة" : null,
                ),
                const Gap(20),

                // حقل تأكيد كلمة المرور
                _buildCustomField(
                  controller: _confirmPasswordController,
                  label: "تأكيد كلمة المرور",
                  hint: "••••••••",
                  icon: Icons.lock_reset_rounded,
                  isPassword: true,
                  obscureText: !_isConfirmVisible,
                  togglePassword: () =>
                      setState(() => _isConfirmVisible = !_isConfirmVisible),
                  validator: (val) {
                    if (val != _passwordController.text) {
                      return "كلمة المرور غير متطابقة";
                    }
                    return null;
                  },
                ),

                const Gap(40),

                // زر إنشاء الحساب
                _buildRegisterButton(),

                const Gap(30),
                // رابط العودة لتسجيل الدخول
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "لديك حساب بالفعل؟ ",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ميثود بناء الحقول
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
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
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
            // كود التسجيل الفعلي هنا
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
          "إنشاء الحساب",
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
