import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text(
          "تتبع الطلب",
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
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildOrderInfoCard(),
            const Gap(30),
            _buildTrackingTimeline(),
            const Gap(40),
            _buildSupportCard(),
          ],
        ),
      ),
    );
  }

  // كرت معلومات الطلب العلوي
  Widget _buildOrderInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "رقم الطلب",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                "#ALH-998245",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "تاريخ التوصيل المتوقع",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                "15 أبريل، 2026",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // التايم لاين (شريط التتبع)
  Widget _buildTrackingTimeline() {
    return Column(
      children: [
        _buildTrackItem(
          Icons.shopping_bag_outlined,
          "تم استلام الطلب",
          "10:30 م، 12 أبريل",
          true,
          true,
        ),
        _buildTrackItem(
          Icons.inventory_2_outlined,
          "جاري تجهيز طلبك",
          "10:45 م، 12 أبريل",
          true,
          true,
        ),
        _buildTrackItem(
          Icons.local_shipping_outlined,
          "تم الشحن مع مندوبنا",
          "قيد التنفيذ الآن",
          false,
          true,
        ),
        _buildTrackItem(
          Icons.home_outlined,
          "تم التوصيل",
          "متوقع غداً",
          false,
          false,
        ),
      ],
    );
  }

  Widget _buildTrackItem(
    IconData icon,
    String title,
    String time,
    bool isDone,
    bool hasNext,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الدائرة والخط الجانبي
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDone ? Colors.orange : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDone ? Colors.white : Colors.grey,
                size: 20,
              ),
            ),
            if (hasNext)
              Container(
                width: 2,
                height: 50,
                color: isDone ? Colors.orange : Colors.grey[200],
              ),
          ],
        ),
        const Gap(20),
        // نصوص الحالة
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDone ? Colors.black : Colors.grey,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: isDone ? Colors.grey : Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // كرت الدعم الفني
  Widget _buildSupportCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.headset_mic_outlined, color: Colors.white),
          ),
          const Gap(15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "هل تواجه مشكلة؟",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "تحدث مع خدمة العملاء الآن",
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("مساعدة"),
          ),
        ],
      ),
    );
  }
}
