import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_state.dart';
import 'order_success.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "ملخص الطلب",
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          final items = cartState is CartUpdated ? cartState.cartItems : [];

          double subTotal = items.fold(
            0.0,
            (sum, item) => sum + (item.product.price * item.quantity),
          );
          double shipping = subTotal > 0 ? 25.0 : 0.0;
          double tax = subTotal * 0.15;
          double total = subTotal + shipping + tax;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                _buildSection("المنتجات المختارة", "${items.length}"),
                _buildProductsList(items),
                const Gap(25),
                _buildSection("التوصيل والدفع", ""),

                // داخل صفحة ملخص الطلب - جزء العنوان
                BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, addrState) {
                    // حل مشكلة الـ Null: نتأكد أولاً أن القائمة ليست فارغة
                    if (addrState.addresses.isEmpty) {
                      return _buildInfoTile(
                        Icons.location_off_outlined,
                        "عنوان التوصيل",
                        "لم يتم إضافة عنوان",
                        "اضغط لإضافة عنوان جديد",
                      );
                    }

                    // نأخذ العنوان المختار بأمان
                    final addr = addrState.addresses[addrState.selectedIndex];

                    // نستخدم الـ ?? بدلاً من الـ ! لمنع الانهيار نهائياً
                    String title = addr["title_ar"] ?? addr["title"] ?? "عنوان";
                    String desc =
                        addr["desc_ar"] ?? addr["desc"] ?? "لا يوجد وصف";

                    return _buildInfoTile(
                      Icons.location_on_outlined,
                      "عنوان التوصيل",
                      title,
                      desc,
                    );
                  },
                ),

                const Gap(12),
                _buildInfoTile(
                  Icons.credit_card_outlined,
                  "طريقة الدفع",
                  "Visa Card **** 4422",
                  "الدفع عند الاستلام",
                ),
                const Gap(30),
                _buildPremiumBillCard(subTotal, shipping, tax, total),
                const Gap(40),
                _buildConfirmButton(context, items.isEmpty, total),
                const Gap(30),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- الودجت التي كانت ناقصة وتسبب الخطأ الأحمر ---

  Widget _buildSection(String title, String count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 5),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          if (count.isNotEmpty) ...[
            const Gap(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                count,
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductsList(List items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(item.product.image, width: 40, height: 40),
            ),
            title: Text(
              item.product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            subtitle: Text(
              "الكمية: ${item.quantity}",
              style: const TextStyle(fontSize: 11),
            ),
            trailing: Text(
              "\$${(item.product.price * item.quantity).toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String title, String s) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          const Gap(15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.green, size: 18),
        ],
      ),
    );
  }

  Widget _buildPremiumBillCard(
    double sub,
    double ship,
    double tax,
    double total,
  ) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          _billRow("المجموع الفرعي", "\$${sub.toStringAsFixed(2)}"),
          const Gap(10),
          _billRow("رسوم الشحن", "\$${ship.toStringAsFixed(2)}"),
          const Gap(10),
          _billRow("الضريبة", "\$${tax.toStringAsFixed(2)}"),
          const Divider(color: Colors.white10, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "الإجمالي",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "\$${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _billRow(String l, String v) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(l, style: const TextStyle(color: Colors.white60, fontSize: 13)),
      Text(
        v,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );

  Widget _buildConfirmButton(BuildContext context, bool isEmpty, double total) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: isEmpty
          ? null
          : () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => OrderSuccessScreen(totalPrice: total),
              ),
              (route) => false,
            ),
      child: const Text(
        "تأكيد ودفع الآن",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
