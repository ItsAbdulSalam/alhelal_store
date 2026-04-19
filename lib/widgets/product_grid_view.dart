import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/productModel.dart';
import '../screens/productsDetails.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/favorites_bloc.dart'; // استيراد بلوك المفضلة
import '../bloc/favorites_event.dart'; // استيراد أحداث المفضلة
import 'product_card.dart';

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
        mainAxisExtent: 280,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final item = products[index];
        return PremiumProductCard(
          product: item,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductsDetailsPage(productdetails: item),
              ),
            );
          },
          // إضافة للسلة
          onAddTap: () {
            context.read<CartBloc>().add(AddToCart(product: item, quantity: 1));
          },
          // إضافة/حذف من المفضلة (تم التفعيل هنا)
          onFavoriteTap: () {
            context.read<FavoritesBloc>().add(ToggleFavorite(product: item));
          },
        );
      },
    );
  }
}
