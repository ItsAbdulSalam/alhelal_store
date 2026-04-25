import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthWelcomeScreen extends StatelessWidget {
  const AuthWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── 1. خلفية دافئة داكنة (بدل الصورة أو السواد الصرف)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -0.2),
                  radius: 1.1,
                  colors: [
                    Color(0xFF1A0800), // بني محمر دافئ في المركز
                    Color(0xFF0D0400),
                    Color(0xFF0A0A0A), // أسود في الأطراف
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // ── 2. Accent bar برتقالي في الأعلى
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.orange.withOpacity(0.7),
                    Colors.deepOrange.withOpacity(0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.35, 0.65, 1.0],
                ),
              ),
            ),
          ),

          // ── 3. نقاط ضوئية زخرفية
          Positioned(
            top: -60,
            left: -60,
            child: _glowCircle(Colors.orange, 160, 0.09),
          ),
          Positioned(
            top: 100,
            right: -50,
            child: _glowCircle(Colors.deepOrange, 110, 0.06),
          ),
          Positioned(
            bottom: 80,
            right: -40,
            child: _glowCircle(Colors.orange, 90, 0.04),
          ),

          // ── 4. المحتوى الأساسي
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Gap(60),

                  // ── الشعار
                  Column(
                    children: [
                      const Hero(
                        tag: 'logo',
                        child: Text(
                          "ALHELAL PRIME",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 5,
                          ),
                        ),
                      ),
                      const Gap(10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.55),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "متجرك المفضل للإلكترونيات",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 11.5,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // ── Hero Section: أيقونات المنتجات العائمة
                  _HeroProductsSection(screenWidth: size.width),

                  const Gap(32),

                  // ── نص ترحيبي
                  const Text(
                    "اكتشف عالماً من التقنية",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(8),
                  Text(
                    "موبايلات · كاميرات · ساعات · سماعات",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 13,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Gap(40),

                  // ── زر تسجيل الدخول
                  _WelcomeButton(
                    label: "تسجيل الدخول",
                    isPrimary: true,
                    onTap: () => Navigator.push(
                      context,
                      _fadeRoute(const LoginScreen()),
                    ),
                  ),

                  const Gap(14),

                  // ── زر إنشاء الحساب
                  _WelcomeButton(
                    label: "إنشاء حساب جديد",
                    isPrimary: false,
                    onTap: () => Navigator.push(
                      context,
                      _fadeRoute(const RegisterScreen()),
                    ),
                  ),

                  const Gap(26),

                  Text(
                    "بالمتابعة، أنت توافق على شروط الاستخدام وسياسة الخصوصية",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 10.5,
                      height: 1.5,
                    ),
                  ),

                  const Gap(20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowCircle(Color color, double radius, double opacity) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(opacity),
      ),
    );
  }

  PageRoute _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}

// ── Hero: أيقونات المنتجات العائمة ─────────────────────────────────────────
class _HeroProductsSection extends StatefulWidget {
  final double screenWidth;
  const _HeroProductsSection({required this.screenWidth});

  @override
  State<_HeroProductsSection> createState() => _HeroProductsSectionState();
}

class _HeroProductsSectionState extends State<_HeroProductsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _float = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: AnimatedBuilder(
        animation: _float,
        builder: (_, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // ── حلقة خارجية
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.12),
                    width: 1,
                  ),
                ),
              ),
              // ── حلقة داخلية
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.22),
                    width: 1,
                  ),
                  color: Colors.orange.withOpacity(0.04),
                ),
              ),

              // ── أيقونة المنتج الرئيسية (موبايل) - تعوم
              Transform.translate(
                offset: Offset(0, _float.value),
                child: _productIcon('📱', 46, 0),
              ),

              // ── أيقونة الكاميرا (يسار علوي)
              Transform.translate(
                offset: Offset(-55, _float.value * 0.6 - 20),
                child: _productIcon('📷', 34, 1),
              ),

              // ── أيقونة السماعات (يمين علوي)
              Transform.translate(
                offset: Offset(55, _float.value * 0.8 - 15),
                child: _productIcon('🎧', 34, 2),
              ),

              // ── أيقونة الساعة (يسار سفلي)
              Transform.translate(
                offset: Offset(-48, _float.value * 0.4 + 30),
                child: _productIcon('⌚', 28, 3),
              ),

              // ── أيقونة اللابتوب (يمين سفلي)
              Transform.translate(
                offset: Offset(50, _float.value * 0.5 + 28),
                child: _productIcon('💻', 28, 4),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _productIcon(String emoji, double size, int index) {
    final delays = [0.0, 0.2, 0.4, 0.6, 0.8];
    final boxSize = size + 16;

    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: Color.lerp(
          const Color(0xFF1A0800),
          const Color(0xFF2A1200),
          delays[index],
        ),
        borderRadius: BorderRadius.circular(boxSize * 0.28),
        border: Border.all(
          color: Colors.orange.withOpacity(0.2 + delays[index] * 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.12),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Text(emoji, style: TextStyle(fontSize: size * 0.58)),
      ),
    );
  }
}

// ── زر الترحيب المحلي ────────────────────────────────────────────────────────
class _WelcomeButton extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _WelcomeButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  State<_WelcomeButton> createState() => _WelcomeButtonState();
}

class _WelcomeButtonState extends State<_WelcomeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              width: double.infinity,
              height: 58,
              decoration: BoxDecoration(
                gradient: widget.isPrimary
                    ? const LinearGradient(
                        colors: [Color(0xFFFF8C00), Color(0xFFFF5500)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: widget.isPrimary ? null : Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: widget.isPrimary
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.2),
                  width: 1.2,
                ),
                boxShadow: widget.isPrimary
                    ? [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.4),
                          blurRadius: 22,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}