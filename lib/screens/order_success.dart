import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'home.dart'; // استيراد الصفحة الرئيسية للعودة إليها

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة النجاح مع أنيميشن بسيط (اختياري)
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.green,
                size: 120,
              ),
              const Gap(25),
              const Text(
                "تم تأكيد طلبك بنجاح!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Gap(15),
              Text(
                "شكراً لتسوقك من رات مارت. سيتم تجهيز طلبك وإرساله إليك في أقرب وقت ممكن.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const Gap(40),
              // زر العودة للتسوق
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // العودة للصفحة الرئيسية وتصفير مسار التنقل
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "العودة للرئيسية",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
