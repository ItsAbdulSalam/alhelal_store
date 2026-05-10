import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart' hide ToggleFavorite;
import '../bloc/favorites_state.dart' hide FavoritesState, FavoritesUpdated;
import '../models/productModel.dart';
import '../shared/app_colors.dart';
import '../screens/productsDetails.dart';

// ═══════════════════════════════════════════════════════════
//  ProductGridView (المحسن)
// ═══════════════════════════════════════════════════════════
class ProductGridView extends StatelessWidget {
  final List<Product> products;
  const ProductGridView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 20),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 285, // زيادة الارتفاع قليلاً لراحة العين
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  ProductCard (التصميم العالمي الجديد)
// ═══════════════════════════════════════════════════════════
class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isPressed = false;

  void _onTap() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, _, _) =>
            ProductsDetailsPage(productdetails: widget.product),
      ),
    );
  }

  void _addToCart() {
    HapticFeedback.mediumImpact(); // اهتزاز أقوى قليلاً للإحساس بالإنجاز
    context.read<CartBloc>().add(AddToCart(product: widget.product));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 18),
            Gap(10),
            Text(
              'أُضيف للحقيبة بنجاح',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(24), // حواف أكثر فخامة
            border: Border.all(color: c.border.withOpacity(0.5), width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // قسم الصورة مع Hero Animation
              Expanded(
                child: Stack(
                  children: [
                    Hero(
                      tag: 'product_${widget.product.id}',
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: c.surfaceHigh.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Image.asset(
                          widget.product.image,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.image_not_supported_outlined,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 15,
                      child: _FavoriteButton(product: widget.product, c: c),
                    ),
                  ],
                ),
              ),

              // قسم التفاصيل
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${widget.product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: c.gold,
                                fontWeight: FontWeight.w900,
                                fontSize: 17,
                              ),
                            ),
                            const Text(
                              "شحن مجاني",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        _buildAddButton(c),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(AppColors c) {
    return GestureDetector(
      onTap: _addToCart,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black, // زر أسود فخم
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_shopping_cart_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

// ── Favorite Button المطور ───────────────────────
class _FavoriteButton extends StatelessWidget {
  final Product product;
  final AppColors c;
  const _FavoriteButton({required this.product, required this.c});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      buildWhen: (p, n) =>
          (p as FavoritesUpdated).isFavorite(product.id) !=
          (n as FavoritesUpdated).isFavorite(product.id),
      builder: (context, state) {
        final isFav = (state as FavoritesUpdated).isFavorite(product.id);
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            context.read<FavoritesBloc>().add(ToggleFavorite(product: product));
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isFav
                  ? Colors.red.withOpacity(0.1)
                  : Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
              ],
            ),
            child: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? Colors.red : Colors.grey,
              size: 18,
            ),
          ),
        );
      },
    );
  }
}
