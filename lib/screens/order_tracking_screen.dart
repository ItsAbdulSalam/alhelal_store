import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class OrderTrackingScreen extends StatelessWidget {
  // إضافة orderData لاستقبال بيانات الطلب الحقيقية
  final Map<String, dynamic> orderData;

  const OrderTrackingScreen({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    // استخراج الحالة الحالية للطلب لتحديد خطوات التتبع
    final String status = orderData['status'] ?? 'قيد التنفيذ';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF3E0), Color(0xFFFBFBFB), Colors.white],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    _buildOrderHeader(status),
                    const Gap(25),
                    _buildTrackingTimeline(status),
                    const Gap(30),
                    _buildDeliveryInforCard(),
                    const Gap(40),
                    _buildBackHomeButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "حالة الطلب",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildOrderHeader(String status) {
    // عرض أول 8 أحرف من الـ Order ID
    final String displayId =
        orderData['orderId']?.toString().substring(0, 8).toUpperCase() ?? "N/A";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "رقم التتبع",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const Gap(5),
              Text(
                "#HP-$displayId",
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(String status) {
    // منطق بسيط لتحديد الخطوات المكتملة بناءً على الحالة في Firebase
    final bool isConfirmed = true; // مؤكد بمجرد الدفع
    final bool isProcessed = status == "قيد التوصيل" || status == "تم التسليم";
    final bool isShipped = status == "قيد التوصيل" || status == "تم التسليم";
    final bool isDelivered = status == "تم التسليم";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          _buildStep(
            Icons.check_circle,
            "تم تأكيد الطلب",
            "تم استلام الدفعة بنجاح",
            isConfirmed,
            true,
          ),
          _buildStep(
            Icons.inventory_2,
            "تم تجهيز الشحنة",
            isProcessed ? "تم تغليف المنتجات" : "جاري التجهيز في المستودع",
            isProcessed,
            true,
          ),
          _buildStep(
            Icons.local_shipping,
            "في الطريق إليك",
            isShipped ? "الشحنة مع المندوب" : "بانتظار خروج الشحنة",
            isShipped,
            true,
          ),
          _buildStep(
            Icons.door_front_door,
            "تم التسليم",
            isDelivered ? "تم التسليم بنجاح" : "متوقع وصولها قريباً",
            isDelivered,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    IconData icon,
    String title,
    String date,
    bool isDone,
    bool showLine,
  ) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Icon(
                icon,
                color: isDone ? Colors.orange : Colors.grey[300],
                size: 28,
              ),
              if (showLine)
                Expanded(
                  child: VerticalDivider(
                    color: isDone ? Colors.orange : Colors.grey[300],
                    thickness: 2,
                  ),
                ),
            ],
          ),
          const Gap(15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDone ? Colors.black : Colors.grey,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Gap(25),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInforCard() {
    // الحصول على اسم المستخدم من بيانات الطلب المرفوعة
    final String addressTitle =
        orderData['address']?['title_ar'] ??
        orderData['address']?['title'] ??
        "العنوان المختار";

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Colors.orange,
            child: Icon(Icons.location_on, color: Colors.white, size: 20),
          ),
          const Gap(15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "وجهة التوصيل",
                  style: TextStyle(color: Colors.white60, fontSize: 11),
                ),
                Text(
                  addressTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {}, // يمكن ربطه لفتح الخريطة لاحقاً
            icon: const Icon(Icons.map_outlined, color: Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildBackHomeButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
      child: const Text(
        "العودة للتسوق",
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }
}
