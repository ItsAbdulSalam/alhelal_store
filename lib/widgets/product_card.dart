import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../models/productModel.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_state.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // منطقة الصورة + زر المفضلة
            Stack(
              children: [
                // عرض الصورة (تأكد من أن product.image يحتوي على المسار الصحيح مثل assets/...)
                Container(
                  height: 150,
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Hero(
                    tag: product.id,
                    child: Image.asset(product.image, fit: BoxFit.contain),
                  ),
                ),
                // زر المفضلة (القلب) مع تحديث لحظي
                Positioned(
                  top: 10,
                  right: 10,
                  child: BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, state) {
                      bool isFav = false;
                      if (state is FavoritesUpdated) {
                        isFav = state.favoritesList.any(
                          (e) => e.id == product.id,
                        );
                      }
                      return GestureDetector(
                        onTap: onFavoriteTap,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFav
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            color: isFav ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // معلومات المنتج (الاسم والسعر وزر الإضافة)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${product.price}",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      // زر الإضافة السريع (+)
                      GestureDetector(
                        onTap: onAddTap,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1A1A1A),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
