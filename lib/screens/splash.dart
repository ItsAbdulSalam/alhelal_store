import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(20),
            Image.asset("assets/images/logo/logo.png", width: 200),
            Gap(20),
            Text(
              " أهلا بك في متجرنا",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            Text(
              "تسوق من أفضل المنتجات بأفضل الأسعار",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            Image.asset("assets/images/splash-img.png", width: 280),
            Gap(20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 70),
              ),
              onPressed: () {},
              child: Text(
                "تسجيل الدخول",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Gap(12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 70),
                side: BorderSide(color: Colors.black, width: 2),
              ),
              onPressed: () {},
              child: Text(
                "إنشاء حساب",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
