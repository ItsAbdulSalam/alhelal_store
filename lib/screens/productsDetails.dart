import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

// استيراد الـ Bloc والملفات الضرورية
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../models/productModel.dart';

class ProductsDetailsPage extends StatefulWidget {
  final Product productdetails;
  const ProductsDetailsPage({super.key, required this.productdetails});

  @override
  State<ProductsDetailsPage> createState() => _ProductsDetailsPageState();
}

class _ProductsDetailsPageState extends State<ProductsDetailsPage> {
  int quantity = 1;
  late String currentImage; // الصورة التي ستتغير عند اختيار اللون

  @override
  void initState() {
    super.initState();
    // تعيين الصورة الأولية من بيانات المنتج
    currentImage = widget.productdetails.image;
  }

  void _handleAddToCart() {
    context.read<CartBloc>().add(
      AddToCart(product: widget.productdetails, quantity: quantity),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "تمت إضافة $quantity من ${widget.productdetails.name} إلى السلة",
        ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
      ),
    );
    // يمكنك إلغاء تفعيل الـ pop إذا أردت بقاء المستخدم في الصفحة
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {}, // يمكنك ربطها بـ FavoritesBloc لاحقاً
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. عرض الصورة مع تأثير انتقال ناعم
            SizedBox(
              height: 350,
              width: double.infinity,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Hero(
                  tag: widget.productdetails.id,
                  child: Image.asset(
                    currentImage,
                    key: ValueKey<String>(currentImage),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 100),
                  ),
                ),
              ),
            ),

            // 2. حاوية المعلومات (Modern Rounded Container)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الاسم والتقييم
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.productdetails.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "4.9 ⭐",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(15),

                  // السعر
                  Text(
                    "\$${widget.productdetails.price}",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.orange,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Gap(25),

                  // 3. قسم اختيار الألوان (ميزة إضافية)
                  const Text(
                    "الألوان المتوفرة",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Gap(15),
                  _buildColorSelector(),

                  const Gap(25),
                  const Text(
                    "الوصف",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Gap(10),
                  Text(
                    widget.productdetails.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                  const Gap(30),

                  // التحكم بالكمية
                  Row(
                    children: [
                      const Text(
                        "الكمية",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      _qtyActionBtn(Icons.remove, () {
                        if (quantity > 1) setState(() => quantity--);
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "$quantity",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _qtyActionBtn(
                        Icons.add,
                        () => setState(() => quantity++),
                      ),
                    ],
                  ),
                  const Gap(100), // مساحة إضافية للسحب
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ويدجت اختيار الألوان (تغيير الصورة عند الضغط)
  Widget _buildColorSelector() {
    // إذا لم يكن للمنتج ألوان، لا تعرض شيئاً
    if (widget.productdetails.variants == null) return const SizedBox();

    return Row(
      children: widget.productdetails.variants!.map((variant) {
        bool isSelected = currentImage == variant.image;
        return GestureDetector(
          onTap: () => setState(() => currentImage = variant.image),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.orange : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: CircleAvatar(backgroundColor: variant.color, radius: 15),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ElevatedButton(
        onPressed: _handleAddToCart,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, // اللون الأسود يعطي طابع Prime أكثر
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 5,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, color: Colors.white),
            Gap(12),
            Text(
              "إضافة إلى السلة",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyActionBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5),
          ],
        ),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }
}
