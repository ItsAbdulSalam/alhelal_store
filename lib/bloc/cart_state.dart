// ═══════════════════════════════════════════════════════════
//  cart_state.dart
// ═══════════════════════════════════════════════════════════
import '../models/productModel.dart';

abstract class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartUpdated extends CartState {
  final List<CartItem> cartItems;
  final double total;
  final int itemCount;

  CartUpdated(List<CartItem> items)
      : cartItems = List.unmodifiable(items),
        total = items.fold(0, (s, i) => s + i.product.price * i.quantity),
        itemCount = items.fold(0, (s, i) => s + i.quantity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartUpdated && cartItems == other.cartItems;

  @override
  int get hashCode => cartItems.hashCode;
}
