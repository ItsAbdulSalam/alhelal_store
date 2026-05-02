import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../shared/app_colors.dart';

class OrderSuccessScreen extends StatelessWidget {
  final double totalPrice;
  const OrderSuccessScreen({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    // استخدام AppColors للحفاظ على تناسق التصميم مع باقي التطبيق
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة النجاح بتصميم جذاب
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 100,
                ),
              ),
              const Gap(30),
              Text(
                "تم الطلب بنجاح!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: c.textPrimary,
                ),
              ),
              const Gap(10),
              Text(
                "شكراً لثقتك بنا، طلبك الآن قيد التنفيذ",
                style: TextStyle(fontSize: 14, color: c.textSecondary),
              ),
              const Gap(30),

              // ملخص الدفع السريع
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: c.border, width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "المبلغ الإجمالي المدفوع",
                      style: TextStyle(color: c.textSecondary, fontSize: 13),
                    ),
                    Text(
                      "\$${totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: c.gold, // استخدام لون الذهب الخاص ببراند الحلال
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(50),

              // زر العودة للرئيسية
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.gold,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // العودة للشاشة الرئيسية وتصفير مسار الملاحة
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/main',
                    (route) => false,
                  );
                },
                child: const Text(
                  "العودة للرئيسية",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
