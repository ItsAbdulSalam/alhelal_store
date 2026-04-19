import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = "ar"; // الافتراضي عربية

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('language_code') ?? "ar";
    });
  }

  Future<void> _changeLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', code);
    setState(() {
      selectedLanguage = code;
    });

    // تنبيه للمستخدم (في التطبيقات الكبيرة نستخدم Provider أو Easy Localization لتحديث المتجر فوراً)
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          code == "ar"
              ? "تم تغيير اللغة للعربية"
              : "Language changed to English",
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "اللغة / Language",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildLanguageItem("العربية", "ar", "🇸🇦"),
            const Gap(15),
            _buildLanguageItem("English", "en", "🇺🇸"),
            const Spacer(),
            const Text(
              "سيتم تطبيق التغييرات على واجهة المتجر بالكامل",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(String name, String code, String flag) {
    bool isSelected = selectedLanguage == code;
    return GestureDetector(
      onTap: () => _changeLanguage(code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.withOpacity(0.05) : Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const Gap(15),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.orange),
          ],
        ),
      ),
    );
  }
}
