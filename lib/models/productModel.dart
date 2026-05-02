import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category; 
  bool isFavorite;
  final List<ProductVariant>? variants;

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'isFavorite': isFavorite,
      'variants': variants?.map((v) => v.toMap()).toList(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      image: map['image'] ?? '',
      category: map['category'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      variants: map['variants'] != null
          ? List<ProductVariant>.from(
              map['variants'].map((v) => ProductVariant.fromMap(v)))
          : null,
    );
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  Map<String, dynamic> toMap() => {
    'product': product.toMap(),
    'quantity': quantity,
  };

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
    product: Product.fromMap(map['product']),
    quantity: map['quantity'] ?? 1,
  );
}

class ProductVariant {
  final Color color;
  final String image;
  ProductVariant({required this.color, required this.image});

  Map<String, dynamic> toMap() => {'color': color.value, 'image': image};
  factory ProductVariant.fromMap(Map<String, dynamic> map) => ProductVariant(
    color: Color(map['color'] ?? 0xFF000000),
    image: map['image'] ?? '',
  );
}