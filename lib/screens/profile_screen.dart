import 'package:first_store/screens/AddressScreen.dart';
import 'package:first_store/screens/EditProfileScreen.dart';
import 'package:first_store/screens/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'order_history_screen.dart'; // استيراد صفحة الطلبات

import 'payment_methods_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      // في ملف profile_screen.dart
      appBar: AppBar(
        title: const Text(
          "الملف الشخصي",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // حذف سهم الرجوع
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(20),
            // 1. صورة المستخدم والاسم
            _buildProfileHeader(),
            const Gap(30),

            // 2. قائمة الخيارات (داخل حاوية بيضاء أنيقة)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileItem(
                    context,
                    Icons.person_outline,
                    "تعديل البيانات",
                    "تغيير الاسم، البريد...",
                    const EditProfileScreen(),
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    context,
                    Icons.receipt_long_outlined,
                    "طلباتي",
                    "سجل المشتريات السابق",
                    const OrderHistoryScreen(),
                  ), // هنا طلباتي
                  _buildDivider(),
                  _buildProfileItem(
                    context,
                    Icons.location_on_outlined,
                    "عناوين التوصيل",
                    "إدارة مواقع الاستلام",
                    const AddressScreen(),
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    context,
                    Icons.credit_card_outlined,
                    "طرق الدفع",
                    "Visa **** 4422",
                    const PaymentMethodsScreen(),
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    context,
                    Icons.notifications_none_outlined,
                    "الإشعارات",
                    "تنبيهات العروض",
                    const NotificationsScreen(), // قمنا بالربط هنا
                  ), // صفحة الاشعارات لاحقاً
                  _buildDivider(),
                  _buildProfileItem(
                    context,
                    Icons.language_outlined,
                    "اللغة",
                    "العربية",
                    null,
                  ),
                ],
              ),
            ),
            const Gap(30),

            // 3. زر تسجيل الخروج
            _buildLogoutButton(),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 2),
              ),
            ),
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                "assets/images/me.jpg",
              ), // صورتك يا بطل
            ),
          ],
        ),
        const Gap(15),
        const Text(
          "عبد السلام الهلال",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Text(
          "abdulsalam@gmail.com",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildProfileItem(
    BuildContext context,
    IconData icon,
    String title,
    String subTitle,
    Widget? targetScreen,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.orange, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(
        subTitle,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      trailing: const Icon(Icons.arrow_back_ios, size: 14, color: Colors.grey),
      onTap: () {
        if (targetScreen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        }
      },
    );
  }

  Widget _buildDivider() =>
      Divider(height: 1, indent: 70, endIndent: 20, color: Colors.grey[100]);

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 60,
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          "تسجيل الخروج",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.red.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
