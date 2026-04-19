import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة إشعارات تجريبية (يمكنك ربطها لاحقاً بـ Firebase)
    final List<Map<String, dynamic>> notifications = [
      {
        "title": "تم تأكيد طلبك!",
        "body": "طلبك رقم #ALH-202499 قيد التجهيز الآن.",
        "time": "منذ دقيقتين",
        "icon": Icons.check_circle_outline,
        "color": Colors.green,
        "isRead": false,
      },
      {
        "title": "عرض خاص لفترة محدودة ⚡",
        "body": "خصم 20% على جميع ملحقات آيفون 15. استخدم كود: HELLAL20",
        "time": "منذ ساعتين",
        "icon": Icons.local_offer_outlined,
        "color": Colors.orange,
        "isRead": false,
      },
      {
        "title": "تم تحديث حالة الطلب",
        "body": "طلبك السابق تم تسليمه بنجاح. نتمنى أن ينال إعجابك!",
        "time": "أمس",
        "icon": Icons.delivery_dining_outlined,
        "color": Colors.blue,
        "isRead": true,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "الإشعارات",
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
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "تحديد الكل كقروء",
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Gap(15),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _buildNotificationItem(item);
              },
            ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: item['isRead'] ? Colors.white : Colors.orange.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: item['isRead']
              ? Colors.grey[100]!
              : Colors.orange.withOpacity(0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: item['color'].withOpacity(0.1),
            child: Icon(item['icon'], color: item['color'], size: 20),
          ),
          const Gap(15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (!item['isRead'])
                      const CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.orange,
                      ),
                  ],
                ),
                const Gap(5),
                Text(
                  item['body'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const Gap(10),
                Text(
                  item['time'],
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[200],
          ),
          const Gap(20),
          const Text(
            "لا توجد إشعارات حالياً",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
