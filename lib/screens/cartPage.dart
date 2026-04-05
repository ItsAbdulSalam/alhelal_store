import 'package:first_store/models/cart_data.dart';
import 'package:first_store/screens/order_success.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // حساب المجموع الكلي
  double get total => globalCartList.fold(
    0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text(
          "سلة المشتريات",
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
      body: globalCartList.isEmpty ? _buildEmptyCart() : _buildCartItems(),
      bottomNavigationBar: globalCartList.isEmpty ? null : _buildCheckoutBar(),
    );
  }

  Widget _buildEmptyCart() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
        const Gap(15),
        const Text(
          "سلتك فارغة حالياً",
          style: TextStyle(color: Colors.grey, fontSize: 18),
        ),
      ],
    ),
  );

  Widget _buildCartItems() => ListView.builder(
    padding: const EdgeInsets.all(20),
    itemCount: globalCartList.length,
    itemBuilder: (context, index) {
      final item = globalCartList[index];
      return Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                item.product.image,
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
            const Gap(15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "\$${item.product.price}",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.orange,
                  ),
                  onPressed: () => setState(
                    () => item.quantity > 1
                        ? item.quantity--
                        : globalCartList.removeAt(index),
                  ),
                ),
                Text(
                  "${item.quantity}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.orange,
                  ),
                  onPressed: () => setState(() => item.quantity++),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );

  Widget _buildCheckoutBar() => Container(
    padding: const EdgeInsets.all(25),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "الإجمالي المستحق",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              "\$${total.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const Gap(20),
        ElevatedButton(
          onPressed: () {
            if (globalCartList.isNotEmpty) {
              // 1. منطق إنهاء الطلب: تفريغ السلة
              globalCartList.clear();

              // 2. الانتقال لشاشة النجاح (بدون إمكانية العودة للسلة مرة أخرى)
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderSuccessScreen(),
                ),
                (route) =>
                    false, // حذف كل الصفحات السابقة من الذاكرة لزيادة الأداء
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 2,
          ),
          child: const Text(
            "تأكيد الطلب والدفع",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
