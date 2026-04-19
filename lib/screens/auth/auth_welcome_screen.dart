import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthWelcomeScreen extends StatelessWidget {
  const AuthWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. صورة الخلفية التي تملأ العرض بالكامل مع تأثير سينمائي
          Positioned.fill(
            child: Image.asset(
              'assets/SplashScreen/2.jpeg', // تأكد من المسار الصحيح
              fit: BoxFit.cover,
            ),
          ),

          // 2. طبقة تظليل ذكية (Overlay) لإبراز الأزرار ومنع تشتت العين
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1), // شفاف في الأعلى لترى الشعار
                    Colors.black.withOpacity(0.6), // تدرج في المنتصف
                    Colors.black.withOpacity(
                      1.0,
                    ), // أسود قاتم في الأسفل لبروز الأزرار
                  ],
                  stops: const [0.0, 0.5, 0.9],
                ),
              ),
            ),
          ),

          // 3. المحتوى الأساسي
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const Gap(60), // مساحة علوية
                  // شعار المتجر العائم
                  const Hero(
                    tag: 'logo',
                    child: Text(
                      "ALHELAL PRIME",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                  ),

                  const Spacer(), // يدفع الأزرار للأسفل بشكل احترافي
                  // زر تسجيل الدخول الملون (الأساسي)
                  _customButton(
                    context,
                    "تسجيل الدخول",
                    Colors.orange,
                    Colors.white,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                  ),

                  const Gap(15),

                  // زر إنشاء الحساب الشفاف (الثانوي)
                  _customButton(
                    context,
                    "إنشاء حساب جديد",
                    Colors.white.withOpacity(0.1),
                    Colors.white,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    ),
                    hasBorder: true,
                  ),

                  const Gap(50), // مساحة سفلية مريحة
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ميثود بناء الأزرار بتصميم عصري (Glassmorphism)
  Widget _customButton(
    BuildContext context,
    String text,
    Color bg,
    Color txt,
    VoidCallback onTap, {
    bool hasBorder = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // تأثير الزجاج المشوش
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: bg,
              foregroundColor: txt,
              elevation: bg == Colors.orange ? 10 : 0,
              shadowColor: Colors.orange.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: hasBorder
                    ? const BorderSide(color: Colors.white38, width: 1.2)
                    : BorderSide.none,
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
