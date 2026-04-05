import 'package:first_store/widgets/CustomTextFiled.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  static const Color ratmartOrange = Color(0xFFFF9F00);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // الـ AppBar هنا شفاف تماماً ولا يظهر له أي حدود
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          // أيقونة الرجوع بشكل عصري (iOS Style)
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // مسافة علوية لتعويض غياب الـ AppBar الضخم
                const Gap(20),

                // 1. الشعار
                Image.asset(
                  'assets/images/logo/logo.png',
                  height: 60,
                  fit: BoxFit.contain,
                ),

                const Gap(10),

                const Text(
                  "نموذج حساب جديد",
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),

                const Gap(40),

                // 2. الحقول (CustomTextField)
                CustomTextField(
                  controller: _nameController,
                  labelText: '',
                  hintText: 'الرجاء إدخال الاسم الكامل',
                  prefixIcon: Icons.person_outline,
                  validator: (value) => value!.isEmpty ? "الاسم مطلوب" : null,
                ),
                const Gap(15),

                CustomTextField(
                  controller: _emailController,
                  labelText: '',
                  hintText: 'الرجاء إدخال البريد الإلكتروني',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.contains('@') ? null : "البريد غير صحيح",
                ),
                const Gap(15),

                CustomTextField(
                  controller: _passwordController,
                  labelText: '',
                  hintText: 'الرجاء إدخال كلمة المرور',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) =>
                      value!.length < 8 ? "كلمة المرور قصيرة" : null,
                ),
                const Gap(15),

                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: '',
                  hintText: 'تأكيد كلمة المرور',
                  prefixIcon: Icons.lock_reset_outlined,
                  isPassword: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return "كلمات المرور غير متطابقة";
                    }
                    return null;
                  },
                ),

                const Gap(40),

                // 3. زر التسجيل البرتقالي
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // منطق التسجيل
                      }
                    },
                    icon: const Icon(
                      Icons.person_add_alt_1_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      "إنشاء الحساب",
                      style: TextStyle(fontSize: 17),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ratmartOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 1,
                    ),
                  ),
                ),

                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
