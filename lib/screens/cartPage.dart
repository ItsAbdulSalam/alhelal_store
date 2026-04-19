import 'package:first_store/bloc/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

// استيراد الـ Bloc والـ Models الضرورية
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../models/cart_data.dart';
import 'order_summary_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  // دالة لحساب المجموع الكلي
  double _calculateTotal(List<dynamic> items) {
    return items.fold(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text(
          "حقيبة التسوق",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      // الاستماع لتغييرات الـ Bloc لتحديث القائمة وزر الدفع
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartUpdated && state.cartItems.isNotEmpty) {
            // السحر هنا في الـ Stack لكي يظهر زر الدفع "فوق" القائمة
            return Stack(
              children: [
                _buildCartList(context, state.cartItems), // القائمة
                _buildCheckoutBar(context, state.cartItems), // زر الدفع
              ],
            );
          }
          return _buildEmptyState(); // السلة فارغة
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]),
          const Gap(20),
          const Text(
            "سلة المشتريات فارغة",
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(BuildContext context, List<dynamic> items) {
    return ListView.builder(
      // التعديل 1: مساحة في الأسفل لضمان عدم اختباء المنتج الأخير
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 180),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
            ],
          ),
          child: Row(
            children: [
              // صورة المنتج
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(item.product.image, fit: BoxFit.contain),
              ),
              const Gap(15),
              // تفاصيل المنتج
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const Gap(5),
                    Text(
                      "\$${item.product.price}",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              // التحكم في الكمية + زر الحذف
              Column(
                children: [
                  // زر الحذف (أضفناه في الأعلى بلون أحمر ناعم)
                  IconButton(
                    onPressed: () {
                      context.read<CartBloc>().add(
                        RemoveFromCart(product: item.product),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("تم حذف ${item.product.name} من السلة"),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const Gap(8),
                  // التحكم في الكمية
                  _qtyBtn(
                    Icons.add,
                    () => context.read<CartBloc>().add(
                      UpdateQuantity(product: item.product, isIncrement: true),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "${item.quantity}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _qtyBtn(
                    Icons.remove,
                    () => context.read<CartBloc>().add(
                      UpdateQuantity(product: item.product, isIncrement: false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  // التعديل 2: زر الدفع الآن يتم وضعه في الأسفل يدوياً لكي لا يختبئ خلف البار العائم
  Widget _buildCheckoutBar(BuildContext context, List<dynamic> items) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "الإجمالي المستحق",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "\$${_calculateTotal(items).toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Gap(20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 65),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  // التأكد من أن السلة ليست فارغة قبل الانتقال
                  if (globalCartList.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrderSummaryScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("حقيبة التسوق فارغة!")),
                    );
                  }
                },
                child: const Text(
                  "إتمام الدفع",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            // التعديل 3: ترك مساحة بيضاء إضافية لكي يظهر زر الدفع "فوق" البار السفلي تماماً
            const Gap(90),
          ],
        ),
      ),
    );
  }
}
