// ═══════════════════════════════════════════════════════════
//  product_card.dart — themed, BLoC-powered, const everywhere
// ═══════════════════════════════════════════════════════════
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
//  ProductGridView
// ═══════════════════════════════════════════════════════════
class ProductGridView extends StatelessWidget {
  final List<Product> products;
  const ProductGridView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 272,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  ProductCard
// ═══════════════════════════════════════════════════════════
class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _pressed = false;

  void _onTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) =>
              ProductsDetailsPage(productdetails: widget.product)),
    );
  }

  void _addToCart() {
    
    HapticFeedback.lightImpact();
    context
        .read<CartBloc>()
        .add(AddToCart(product: widget.product));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(_buildSnack(context));
  }

  SnackBar _buildSnack(BuildContext context) {
    final c = AppColors.of(context);
    return SnackBar(
      content: Text('تمت الإضافة إلى السلة',
          style: TextStyle(color: c.textPrimary, fontSize: 13)),
      backgroundColor: c.surface,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: c.border, width: 0.5)),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        _onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.border, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة + زر المفضلة
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                      child: Container(
                        width: double.infinity,
                        color: c.surfaceHigh,
                        child: Image.asset(
                          widget.product.image,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                              Icons.image_outlined,
                              color: c.textMuted,
                              size: 32),
                        ),
                      ),
                    ),
                    // زر المفضلة
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _FavoriteButton(
                          product: widget.product, c: c),
                    ),
                  ],
                ),
              ),

              // التفاصيل
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.product.name,
                        style: TextStyle(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const Gap(6),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: c.gold,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        _AddToCartBtn(onTap: _addToCart, c: c),
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
}

// ── Favorite Button (BLoC-powered) ───────────────────────
class _FavoriteButton extends StatelessWidget {
  final Product product;
  final AppColors c;
  const _FavoriteButton({required this.product, required this.c});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      // buildWhen: يبني فقط عندما تتغير حالة هذا المنتج تحديداً
      buildWhen: (p, n) =>
          (p as FavoritesUpdated).isFavorite(product.id) !=
          (n as FavoritesUpdated).isFavorite(product.id),
      builder: (context, state) {
        final isFav =
            (state as FavoritesUpdated).isFavorite(product.id);
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            context
                .read<FavoritesBloc>()
                .add(ToggleFavorite(product: product));
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isFav
                  ? c.error.withOpacity(0.1)
                  : c.surface.withOpacity(0.85),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: isFav
                      ? c.error.withOpacity(0.3)
                      : c.border,
                  width: 0.5),
            ),
            child: Icon(
              isFav
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded,
              color: isFav ? c.error : c.textMuted,
              size: 15,
            ),
          ),
        );
      },
    );
  }
}

// ── Add to Cart Button ───────────────────────────────────
class _AddToCartBtn extends StatelessWidget {
  final VoidCallback onTap;
  final AppColors c;
  const _AddToCartBtn({required this.onTap, required this.c});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: c.gold,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add_rounded,
            color: Colors.white, size: 18),
      ),
    );
  }
}
