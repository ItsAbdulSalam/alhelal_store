import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category; // حقل أساسي للفلترة في البلوك
  bool isFavorite;
  final List<ProductVariant>? variants; // أضف هذا السطر

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.isFavorite = false,
    this.variants,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class ProductVariant {
  final Color color;
  final String image;

  ProductVariant({required this.color, required this.image});
}
