// ═══════════════════════════════════════════════════════════
//  favorites_screen.dart — clean BLoC, no dead code
// ═══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart' hide ToggleFavorite;
import '../bloc/favorites_state.dart' hide FavoritesState, FavoritesUpdated;
import '../models/productModel.dart';
import '../shared/app_colors.dart';
import 'productsDetails.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppBar(
        backgroundColor: c.bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('المفضلة',
            style: TextStyle(
                color: c.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            buildWhen: (p, n) =>
                (p as FavoritesUpdated).items.length !=
                (n as FavoritesUpdated).items.length,
            builder: (context, state) {
              final count = (state as FavoritesUpdated).items.length;
              if (count == 0) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('$count',
                      style: TextStyle(
                          color: c.gold,
                          fontWeight: FontWeight.w700,
                          fontSize: 12)),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          final items = (state as FavoritesUpdated).items;
          if (items.isEmpty) return _EmptyFavorites(c: c);

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 240,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (_, i) =>
                _FavoriteCard(product: items[i], c: c),
          );
        },
      ),
    );
  }
}

// ── Empty State ──────────────────────────────────────────
class _EmptyFavorites extends StatelessWidget {
  final AppColors c;
  const _EmptyFavorites({required this.c});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_outline_rounded, size: 72, color: c.textMuted),
          const Gap(16),
          Text('قائمة المفضلة فارغة',
              style: TextStyle(
                  color: c.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          const Gap(8),
          Text('أضف المنتجات التي تعجبك',
              style: TextStyle(color: c.textMuted, fontSize: 13)),
        ],
      ),
    );
  }
}

// ── Favorite Card ────────────────────────────────────────
class _FavoriteCard extends StatelessWidget {
  final Product product;
  final AppColors c;
  const _FavoriteCard({required this.product, required this.c});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                ProductsDetailsPage(productdetails: product)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)),
                    child: Container(
                      width: double.infinity,
                      color: c.surfaceHigh,
                      child: Image.asset(product.image,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, ___) => Icon(
                              Icons.image_outlined,
                              color: c.textMuted)),
                    ),
                  ),
                  // زر حذف
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.read<FavoritesBloc>().add(
                            ToggleFavorite(product: product));
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: c.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.favorite_rounded,
                            color: c.error, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // تفاصيل
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const Gap(4),
                  Text('\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: c.gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
