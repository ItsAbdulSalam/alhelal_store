import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../models/productModel.dart';
import 'order_tracking_screen.dart'; // تأكد من استيراد صفحة التتبع

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: uid == null
          ? const Center(child: Text("يرجى تسجيل الدخول أولاً"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('orders')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.orange));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 80, color: Colors.grey[300]),
                        const Gap(15),
                        const Text("لا يوجد طلبات سابقة حتى الآن",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                final orderDocs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: orderDocs.length,
                  itemBuilder: (context, index) {
                    final order = orderDocs[index].data() as Map<String, dynamic>;
                    final List items = order['items'] ?? [];
                    
                    // تنسيق التاريخ بأمان
                    String formattedDate = "تاريخ غير معروف";
                    if (order['createdAt'] != null) {
                      DateTime date = (order['createdAt'] as Timestamp).toDate();
                      formattedDate = DateFormat('yyyy/MM/dd - hh:mm a').format(date);
                    }

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
                                      "طلب رقم: ${order['orderId'].toString().substring(0, 8)}...",
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                                    ),
                                  ],
                                ),
                                _buildStatusBadge(order['status'] ?? 'قيد المعالجة'),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          
                          // عرض أول منتج في الطلب كصورة وعنوان
                          if (items.isNotEmpty)
                            _buildOrderItemTile(items[0], order['totalPrice']),
                          
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                // زر إعادة طلب - يقوم بإضافة المنتجات للسلة مجدداً
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      for (var itemData in items) {
                                        final product = Product.fromMap(itemData['product']);
                                        context.read<CartBloc>().add(AddToCart(
                                          product: product, 
                                          quantity: itemData['quantity'] ?? 1
                                        ));
                                      }
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("تمت إضافة المنتجات إلى حقيبتك"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text("إعادة طلب", style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                const Gap(10),
                                // زر التفاصيل - ينقلك لصفحة تتبع الطلب
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrderTrackingScreen(orderData: order),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text("التفاصيل", style: TextStyle(color: Colors.black)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.orange;
    if (status == "تم التوصيل") color = Colors.green;
    if (status == "ملغي") color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildOrderItemTile(Map<String, dynamic> item, dynamic total) {
    // حل مشكلة الصور: التحقق إذا كان المسار محلي (assets) أو رابط (http)
    String imagePath = item['product']['image'] ?? '';
    bool isNetworkImage = imagePath.startsWith('http');

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 70,
              height: 70,
              color: Colors.grey[100],
              child: isNetworkImage 
                ? Image.network(
                    imagePath, 
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
                  )
                : Image.asset(
                    imagePath, 
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
            ),
          ),
          const Gap(15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['product']['name'], 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text("الكمية: ${item['quantity']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  "\$${total.toString()}",
                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}