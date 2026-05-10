import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final List<ProductVariant> variants;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.variants = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image, // ✅ التأكد من إرسال الصورة للسلة
      'category': category,
      'variants': variants.map((v) => v.toMap()).toList(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    // تصحيح: فحص الحقول بشكل فردي لضمان عدم سقوط أي منها أثناء التحويل من Map
    return Product(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'منتج غير معروف',
      description: map['description']?.toString() ?? '',
      price: (map['price'] ?? 0).toDouble(),
      image: map['image']?.toString() ?? '', // ✅ الحقل الحرج
      category: map['category']?.toString() ?? '',
      variants:
          (map['variants'] as List?)
              ?.map((v) => ProductVariant.fromMap(v as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ProductVariant {
  final Color color;
  final String image;
  final String colorName;

  ProductVariant({
    required this.color,
    required this.image,
    this.colorName = '',
  });

  Map<String, dynamic> toMap() => {
    'color': color.value,
    'image': image,
    'colorName': colorName,
  };

  factory ProductVariant.fromMap(Map<String, dynamic> map) => ProductVariant(
    color: Color(map['color'] is int ? map['color'] : 0xFF000000),
    image: map['image']?.toString() ?? '',
    colorName: map['colorName']?.toString() ?? '',
  );
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  Map<String, dynamic> toMap() => {
    'product': product
        .toMap(), // ✅ استدعاء toMap الخاص بالمنتج لضمان حفظ الصورة
    'quantity': quantity,
  };

  factory CartItem.fromMap(Map<String, dynamic> map) {
    // تصحيح جذري: فحص البيانات المتداخلة (Nested Data)
    final productData = map['product'] as Map<String, dynamic>? ?? {};

    return CartItem(
      product: Product.fromMap(productData),
      quantity: map['quantity'] ?? 1,
    );
  }
}
