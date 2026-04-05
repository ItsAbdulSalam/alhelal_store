import 'package:first_store/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('ar'), // تعيين اللغة العربية كلغة افتراضية
      supportedLocales: [Locale('ar')], // دعم اللغة العربية فقط
      localizationsDelegates: [
        // إضافة المترجمات اللازمة للغة العربية
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: "First Store",
      theme: ThemeData(fontFamily: "cairo"),
      home: HomeScreen(),
    );
  }
}
