import 'package:first_store/models/cart_data.dart';
import 'package:first_store/screens/cartPage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../models/productModel.dart';

class ProductsDetailsPage extends StatefulWidget {
  final Product productdetails;
  const ProductsDetailsPage({super.key, required this.productdetails});

  @override
  State<ProductsDetailsPage> createState() => _ProductsDetailsPageState();
}

class _ProductsDetailsPageState extends State<ProductsDetailsPage> {
  int quantity = 1;
  int selectedColorIndex = 0; // لمتابعة اللون المختار

  // قائمة ألوان افتراضية (يمكنك نقلها للموديل لاحقاً)
  final List<Color> productColors = [
    Colors.black,
    Colors.deepPurple,
    const Color(0xFFE5E5E5), // فضي
    const Color(0xFFF5E1C0), // ذهبي
  ];

  void _handleAddToCart() {
    int index = globalCartList.indexWhere(
      (item) => item.product.id == widget.productdetails.id,
    );
    setState(() {
      if (index != -1) {
        globalCartList[index].quantity += quantity;
      } else {
        globalCartList.add(
          CartItem(product: widget.productdetails, quantity: quantity),
        );
      }
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
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
          IconButton(
            icon: Icon(
              widget.productdetails.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () => setState(
              () => widget.productdetails.isFavorite =
                  !widget.productdetails.isFavorite,
            ),
          ),
          const Gap(10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. عرض الصورة مع Hero
            Container(
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Hero(
                tag: widget.productdetails.image,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Image.asset(
                    widget.productdetails.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. الاسم والتقييم
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.productdetails.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 18),
                            Gap(5),
                            Text(
                              "4.9",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  Text(
                    "\$${widget.productdetails.price}",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Gap(25),

                  // 3. اختيار الألوان (جديد)
                  const Text(
                    "الألوان المتوفرة",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Gap(12),
                  Row(
                    children: List.generate(productColors.length, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => selectedColorIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 15),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColorIndex == index
                                  ? Colors.orange
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: productColors[index],
                          ),
                        ),
                      );
                    }),
                  ),

                  const Gap(30),

                  // 4. الوصف بخط أفضل
                  const Text(
                    "الوصف",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Gap(10),
                  Text(
                    widget.productdetails.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      height: 1.6,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Gap(35),

                  // 5. التحكم بالكمية
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildQtyBtn(
                        Icons.remove,
                        () => setState(() => quantity > 1 ? quantity-- : null),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          "$quantity",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildQtyBtn(Icons.add, () => setState(() => quantity++)),
                    ],
                  ),
                  const Gap(100), // مساحة للسكرول خلف الزر الثابت
                ],
              ),
            ),
          ],
        ),
      ),

      // 6. زر الإضافة للسلة الثابت
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: _handleAddToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 0,
          ),
          child: const Text(
            "إضافة إلى السلة",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback action) => InkWell(
    onTap: action,
    borderRadius: BorderRadius.circular(15),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, size: 22, color: Colors.black),
    ),
  );
}
