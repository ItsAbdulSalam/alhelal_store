import 'package:first_store/models/productModel.dart';

abstract class CartEvent {
  const CartEvent();
}

// إضافة منتج (نمرر المنتج والكمية المختارة)
class AddToCart extends CartEvent {
  final dynamic product;
  final int quantity;
  const AddToCart({required this.product, required this.quantity});
}

// تحديث الكمية داخل السلة
class UpdateQuantity extends CartEvent {
  final dynamic product;
  final bool isIncrement;
  const UpdateQuantity({required this.product, required this.isIncrement});
}

// حذف منتج
class RemoveFromCart extends CartEvent {
  final dynamic product;
  const RemoveFromCart({required this.product});
}

// مسح السلة
class ClearCart extends CartEvent {}
