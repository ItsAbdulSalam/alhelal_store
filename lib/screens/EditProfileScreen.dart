import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // وحدات التحكم بالنصوص لاستقبال البيانات من المستخدم
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // تحميل البيانات المحفوظة عند فتح الصفحة
  }

  // تحميل البيانات من ذاكرة الهاتف
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? "عبد السلام";
      _emailController.text =
          prefs.getString('user_email') ?? "abdulsalam@example.com";
      _phoneController.text =
          prefs.getString('user_phone') ?? "+90 5xx xxx xx xx";
    });
  }

  // حفظ البيانات الجديدة في ذاكرة الهاتف
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    await prefs.setString('user_email', _emailController.text);
    await prefs.setString('user_phone', _phoneController.text);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم تحديث البيانات بنجاح!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context); // العودة لصفحة الملف الشخصي بعد الحفظ
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "تعديل الملف الشخصي",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            // صورة الملف الشخصي (يمكن تطويرها لاحقاً لاختيار صورة من المعرض)
            Stack(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFFF5F5F5),
                  child: Icon(Icons.person, size: 60, color: Colors.grey),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(40),

            // حقول الإدخال
            _buildTextField(
              "الاسم الكامل",
              _nameController,
              Icons.person_outline,
            ),
            const Gap(20),
            _buildTextField(
              "البريد الإلكتروني",
              _emailController,
              Icons.email_outlined,
            ),
            const Gap(20),
            _buildTextField(
              "رقم الهاتف",
              _phoneController,
              Icons.phone_android_outlined,
            ),

            const Gap(50),

            // زر الحفظ
            ElevatedButton(
              onPressed: _saveUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "حفظ التغييرات",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت مخصص لبناء حقول الإدخال بشكل أنيق
  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const Gap(8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.orange),
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.orange, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
