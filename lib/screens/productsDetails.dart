import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../models/productModel.dart';

class ProductsDetailsPage extends StatefulWidget {
  final Product productdetails;
  const ProductsDetailsPage({super.key, required this.productdetails});

  @override
  State<ProductsDetailsPage> createState() => _ProductsDetailsPageState();
}

class _ProductsDetailsPageState extends State<ProductsDetailsPage>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  late String _currentImage;
  Color? _selectedColor;

  // ── Animation controller للصورة ──
  late final AnimationController _imgCtrl;
  late final Animation<double> _imgScale;
  late final Animation<double> _imgOpacity;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.productdetails.image;
    _selectedColor = widget.productdetails.variants.first.color;

    _imgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _imgScale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _imgCtrl, curve: Curves.easeOutBack));
    _imgOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _imgCtrl, curve: Curves.easeOut));
    _imgCtrl.forward();
  }

  @override
  void dispose() {
    _imgCtrl.dispose();
    super.dispose();
  }

  // ── تغيير الصورة مع animation ──
  Future<void> _changeImage(String newImage, Color color) async {
    HapticFeedback.selectionClick();
    await _imgCtrl.reverse();
    if (!mounted) return;
    setState(() {
      _currentImage = newImage;
      _selectedColor = color;
    });
    _imgCtrl.forward();
  }

  void _handleAddToCart() {
    HapticFeedback.heavyImpact();
    context.read<CartBloc>().add(
      AddToCart(product: widget.productdetails, quantity: _quantity),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.shopping_bag_rounded,
              color: Colors.white,
              size: 20,
            ),
            const Gap(10),
            Text(
              'تمت إضافة $_quantity قطعة للسلة',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F0F0F)
          : const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ──
            _AppBar(productName: widget.productdetails.name),

            // ── منطقة الصورة ──
            Expanded(
              flex: 4,
              child: _ImageSection(
                currentImage: _currentImage,
                imgScale: _imgScale,
                imgOpacity: _imgOpacity,
                isDark: isDark,
              ),
            ),

            // ── تفاصيل المنتج ──
            Expanded(
              flex: 6,
              child: _DetailsSection(
                product: widget.productdetails,
                quantity: _quantity,
                selectedColor: _selectedColor,
                isDark: isDark,
                onColorChanged: _changeImage,
                onQuantityChanged: (val) => setState(() => _quantity = val),
              ),
            ),
          ],
        ),
      ),

      // ── زر الإضافة للسلة ──
      bottomNavigationBar: _BottomBar(
        price: widget.productdetails.price,
        quantity: _quantity,
        isDark: isDark,
        onAddToCart: _handleAddToCart,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  _AppBar
// ══════════════════════════════════════════════════════════
class _AppBar extends StatelessWidget {
  final String productName;
  const _AppBar({required this.productName});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // زر الرجوع
          _CircleButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
            isDark: isDark,
          ),
          const Spacer(),
          // اسم المنتج مختصر
          Text(
            productName,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          // زر المفضلة
          _CircleButton(
            icon: Icons.favorite_border_rounded,
            onTap: () {
              HapticFeedback.lightImpact();
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  _CircleButton
// ══════════════════════════════════════════════════════════
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200,
            width: 0.5,
          ),
        ),
        child: Icon(
          icon,
          size: 17,
          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  _ImageSection
// ══════════════════════════════════════════════════════════
class _ImageSection extends StatelessWidget {
  final String currentImage;
  final Animation<double> imgScale;
  final Animation<double> imgOpacity;
  final bool isDark;

  const _ImageSection({
    required this.currentImage,
    required this.imgScale,
    required this.imgOpacity,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
          width: 0.5,
        ),
      ),
      child: Stack(
        children: [
          // ── الصورة مع animation ──
          Center(
            child: AnimatedBuilder(
              animation: imgScale,
              builder: (_, child) => Transform.scale(
                scale: imgScale.value,
                child: Opacity(opacity: imgOpacity.value, child: child),
              ),
              child: Hero(
                tag: 'product_$currentImage',
                child: Image.asset(
                  currentImage,
                  fit: BoxFit.contain,
                  cacheWidth: 600,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.image_outlined,
                    size: 80,
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                  ),
                ),
              ),
            ),
          ),

          // ── Badge عرض خاص ──
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: const Text(
                'OFFER ✦',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  _DetailsSection
// ══════════════════════════════════════════════════════════
class _DetailsSection extends StatelessWidget {
  final Product product;
  final int quantity;
  final Color? selectedColor;
  final bool isDark;
  final Future<void> Function(String, Color) onColorChanged;
  final void Function(int) onQuantityChanged;

  const _DetailsSection({
    required this.product,
    required this.quantity,
    required this.selectedColor,
    required this.isDark,
    required this.onColorChanged,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF8F8F8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── التقييم والاسم والسعر ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // التقييم
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                  const Gap(3),
                  const Text(
                    '4.9',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  Text(
                    '  (120 مراجعة)',
                    style: TextStyle(
                      color: isDark ? Colors.grey[600] : Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              // متوفر
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'متوفر ✓',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const Gap(8),

          Text(
            product.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              letterSpacing: -0.5,
            ),
          ),

          const Gap(4),

          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 22,
              color: Colors.orange,
              fontWeight: FontWeight.w900,
            ),
          ),

          const Gap(14),

          // ── اختيار اللون ──
          if (product.variants.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  'اللون: ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                Text(
                  product.variants
                      .firstWhere(
                        (v) => v.color == selectedColor,
                        orElse: () => product.variants.first,
                      )
                      .colorName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const Gap(10),
            _ColorSelector(
              variants: product.variants,
              selectedColor: selectedColor,
              isDark: isDark,
              onColorChanged: onColorChanged,
            ),
            const Gap(14),
          ],

          // ── الوصف ──
          Text(
            'عن المنتج',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const Gap(5),
          Text(
            product.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey[600],
              height: 1.5,
              fontSize: 12,
            ),
          ),

          const Spacer(),

          // ── الكمية ──
          _QuantityRow(
            quantity: quantity,
            isDark: isDark,
            onChanged: onQuantityChanged,
          ),

          const Gap(12),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  _ColorSelector — اختيار اللون مع تغيير الصورة
// ══════════════════════════════════════════════════════════
class _ColorSelector extends StatelessWidget {
  final List<dynamic> variants;
  final Color? selectedColor;
  final bool isDark;
  final Future<void> Function(String, Color) onColorChanged;

  const _ColorSelector({
    required this.variants,
    required this.selectedColor,
    required this.isDark,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: variants.map((variant) {
        final isSelected = selectedColor == variant.color;
        return GestureDetector(
          onTap: () => onColorChanged(variant.image, variant.color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.only(left: 10),
            width: isSelected ? 38 : 34,
            height: isSelected ? 38 : 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.orange : Colors.transparent,
                width: 2.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                color: variant.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF2A2A2A)
                      : Colors.grey.shade200,
                  width: 0.5,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  _QuantityRow
// ══════════════════════════════════════════════════════════
class _QuantityRow extends StatelessWidget {
  final int quantity;
  final bool isDark;
  final void Function(int) onChanged;

  const _QuantityRow({
    required this.quantity,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'الكمية',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        const Spacer(),
        _QtyButton(
          icon: Icons.remove_rounded,
          onTap: quantity > 1
              ? () {
                  HapticFeedback.lightImpact();
                  onChanged(quantity - 1);
                }
              : null,
          isDark: isDark,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$quantity',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
        ),
        _QtyButton(
          icon: Icons.add_rounded,
          onTap: quantity < 5
              ? () {
                  HapticFeedback.lightImpact();
                  onChanged(quantity + 1);
                }
              : null,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDark;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDisabled
              ? (isDark ? const Color(0xFF1A1A1A) : Colors.grey.shade100)
              : (isDark ? const Color(0xFF2A2A2A) : Colors.white),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200,
            width: 0.5,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isDisabled
              ? Colors.grey
              : (isDark ? Colors.white : const Color(0xFF1A1A1A)),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  _BottomBar
// ══════════════════════════════════════════════════════════
class _BottomBar extends StatelessWidget {
  final double price;
  final int quantity;
  final bool isDark;
  final VoidCallback onAddToCart;

  const _BottomBar({
    required this.price,
    required this.quantity,
    required this.isDark,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final total = price * quantity;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F0F0F) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.grey.shade100,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // ── السعر الإجمالي ──
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الإجمالي',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.grey[600] : Colors.grey[500],
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          const Gap(16),

          // ── زر الإضافة ──
          Expanded(
            child: GestureDetector(
              onTap: onAddToCart,
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    Gap(8),
                    Text(
                      'إضافة للسلة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
