import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../models/productModel.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_state.dart' hide FavoritesState, FavoritesUpdated;

class PremiumProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddTap;
  final VoidCallback onFavoriteTap;

  const PremiumProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // حساب ارتفاع منطقة الصورة ليكون متناسباً مع العرض
        double imageHeight = constraints.maxWidth * 0.9;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            // التعديل 1: تفعيل الـ clipBehavior لضمان عدم خروج أي خلفية عن الحواف المنحنية
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white, // خلفية موحدة للكارد بالكامل
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. منطقة الصورة (تم إزالة الألوان والخلفيات المتداخلة)
                    SizedBox(
                      height: imageHeight,
                      width: double.infinity,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(
                            15.0,
                          ), // مساحة للتنفس حول المنتج
                          child: Hero(
                            tag: product.id,
                            child: Image.asset(
                              product.image,
                              fit: BoxFit
                                  .contain, // يحافظ على أبعاد الصورة الأصلية
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 2. معلومات المنتج
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF1A1A1A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Gap(4),
                          Text(
                            "\$${product.price}",
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // 3. زر الإضافة السريع في الزاوية (تصميم مدمج)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onAddTap,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                        ),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),

                // 4. زر المفضلة (القلب)
                Positioned(top: 12, right: 12, child: _buildFavoriteIcon()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavoriteIcon() {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        bool isFav = false;
        if (state is FavoritesUpdated) {
          // ignore: unnecessary_cast
          isFav = (state as FavoritesUpdated).isFavorite(product.id);
        }
        return GestureDetector(
          onTap: onFavoriteTap,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
              ],
            ),
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border_rounded,
              color: isFav ? Colors.red : Colors.grey[400],
              size: 18,
            ),
          ),
        );
      },
    );
  }
}
