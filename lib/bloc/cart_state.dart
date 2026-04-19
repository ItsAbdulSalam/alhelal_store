abstract class CartState {
  const CartState();
}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<dynamic> cartItems;
  const CartUpdated(this.cartItems);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartUpdated &&
          runtimeType == other.runtimeType &&
          cartItems == other.cartItems;

  @override
  int get hashCode => cartItems.hashCode;
}