// ═══════════════════════════════════════════════════════════
//  cart_event.dart
// ═══════════════════════════════════════════════════════════
import '../models/productModel.dart';

abstract class CartEvent {
  const CartEvent();
}

class AddToCart extends CartEvent {
  final Product product;
  final int quantity;
  const AddToCart({required this.product, this.quantity = 1});
}

class UpdateQuantity extends CartEvent {
  final Product product;
  final bool isIncrement;
  const UpdateQuantity({required this.product, required this.isIncrement});
}

class RemoveFromCart extends CartEvent {
  final Product product;
  const RemoveFromCart({required this.product});
}

class ClearCart extends CartEvent {
  const ClearCart();
}
