import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تأكد من أن هذه المسارات هي نفس التي تستخدمها في الصفحة الرئيسية
    final List<Map<String, dynamic>> orders = [
      {
        "orderId": "#ALH-202499",
        "date": "12 أبريل، 2026",
        "total": "349.00",
        "status": "تم التوصيل",
        "statusColor": Colors.green,
        "items": [
          {
            "name": "Sony WH-1000XM5",
            "image": "assets/images/products/5.jpg", // تأكد من الاسم هنا
            "qty": 1,
          },
        ],
      },
      {
        "orderId": "#ALH-202485",
        "date": "05 أبريل، 2026",
        "total": "1199.99",
        "status": "قيد التوصيل",
        "statusColor": Colors.orange,
        "items": [
          {
            "name": "آيفون 15 برو ماكس",
            "image": 'assets/images/products/1.jpg', // تأكد من الاسم هنا
            "qty": 1,
          },
        ],
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "طلباتي",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
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
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['orderId'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            order['date'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: order['statusColor'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          order['status'],
                          style: TextStyle(
                            color: order['statusColor'],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      // عرض الصورة بشكل صحيح
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          order['items'][0]['image'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                          // لإظهار أيقونة بديلة في حال تعذر التحميل
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[100],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                      const Gap(15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order['items'][0]['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "الكمية: ${order['items'][0]['qty']}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              "\$${order['total']}",
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "إعادة طلب",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "التفاصيل",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
