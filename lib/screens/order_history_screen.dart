import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../models/productModel.dart';
import 'order_tracking_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'طلباتي',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
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
      body: uid == null
          ? const Center(child: Text('يرجى تسجيل الدخول أولاً'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('orders')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const _EmptyState();
                }

                final orderDocs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: orderDocs.length,
                  // ✅ RepaintBoundary لكل كارد
                  itemBuilder: (context, index) {
                    final order =
                        orderDocs[index].data() as Map<String, dynamic>;
                    final List items = order['items'] ?? [];
                    return RepaintBoundary(
                      child: _OrderCard(order: order, items: items),
                    );
                  },
                );
              },
            ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  _OrderCard — widget مستقل بدل دالة
// ══════════════════════════════════════════════════════════
class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final List items;

  const _OrderCard({required this.order, required this.items});

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    if (order['createdAt'] != null) {
      final date = (order['createdAt'] as Timestamp).toDate();
      formattedDate =
          DateFormat('yyyy/MM/dd - hh:mm a').format(date);
    }

    final orderId = order['orderId']?.toString() ?? '';
    final shortId = orderId.length >= 8
        ? orderId.substring(0, 8).toUpperCase()
        : orderId.toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── رأس الكرت ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ✅ Expanded يمنع overflow
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'طلب رقم #$shortId',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Gap(8),
                _StatusBadge(status: order['status'] ?? 'قيد التنفيذ'),
              ],
            ),
          ),

          const Divider(height: 1),

          // ── معاينة المنتج ──
          if (items.isNotEmpty)
            _ProductPreview(
              item: items[0] as Map<String, dynamic>,
              totalPrice: order['totalPrice'],
            ),

          // ── الأزرار ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            OrderTrackingScreen(orderData: order),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade200),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'التفاصيل',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: ElevatedButton(
                    // ✅ استخدم _reorderItems مع context المحلي
                    onPressed: () => _reorderItems(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 0,
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'إعادة طلب',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ الدالة داخل الـ widget — تستخدم context المحلي مباشرة
  void _reorderItems(BuildContext context) {
    for (final itemData in items) {
      final item = itemData as Map<String, dynamic>;
      final product = Product.fromMap(item['product'] as Map<String, dynamic>);
      context.read<CartBloc>().add(
            AddToCart(
              product: product,
              quantity: item['quantity'] as int? ?? 1,
            ),
          );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تمت إضافة المنتجات إلى حقيبتك ✅'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  _ProductPreview — widget مستقل
// ══════════════════════════════════════════════════════════
class _ProductPreview extends StatelessWidget {
  final Map<String, dynamic> item;
  final dynamic totalPrice;

  const _ProductPreview({
    required this.item,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final product = item['product'] as Map<String, dynamic>? ?? {};
    final imagePath = product['image'] as String? ?? '';
    final isNetwork = imagePath.startsWith('http');
    final displayPrice =
        double.tryParse(totalPrice?.toString() ?? '0') ?? 0.0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 70,
              height: 70,
              color: Colors.grey.shade100,
              child: isNetwork
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.broken_image),
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      cacheWidth: 140, // ✅ تقليل استهلاك الذاكرة
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.image),
                    ),
            ),
          ),
          const Gap(15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] as String? ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'الكمية: ${item['quantity']}',
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 12),
                ),
                const Gap(5),
                Text(
                  '\$${displayPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  _StatusBadge — widget مستقل + const
// ══════════════════════════════════════════════════════════
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'تم التوصيل' ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  _EmptyState — const widget
// ══════════════════════════════════════════════════════════
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 70,
            color: Colors.grey.shade300,
          ),
          const Gap(10),
          const Text(
            'لا توجد طلبات حتى الآن',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}