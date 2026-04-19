import 'package:first_store/bloc/favorites_bloc.dart';
import 'package:first_store/bloc/favorites_event.dart';
import 'package:first_store/bloc/favorites_state.dart';
import 'package:first_store/data/favorites_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'productsDetails.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("المفضلة")),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesUpdated && state.favoritesList.isNotEmpty) {
            return ListView.builder(
              itemCount: state.favoritesList.length,
              itemBuilder: (context, index) {
                final product = state.favoritesList[index];
                return ListTile(
                  leading: Image.asset(product.image),
                  title: Text(product.name),
                  subtitle: Text("\$${product.price}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<FavoritesBloc>().add(
                        ToggleFavorite(product: product),
                      );
                    },
                  ),
                );
              },
            );
          }
          // إذا كانت القائمة فارغة (كما في صورتك)
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                Gap(10),
                Text(
                  "قائمة المفضلة فارغة",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ignore: unused_element
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text(
            "قائمة المفضلة فارغة",
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element, strict_top_level_inference
  Widget _buildFavoriteItem(item, index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      color: const Color(0xFFFBFBFB),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Image.asset(
          item.image,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "\$${item.price}",
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            setState(() {
              globalFavoritesList.removeAt(index);
            });
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductsDetailsPage(productdetails: item),
            ),
          );
        },
      ),
    );
  }
}
