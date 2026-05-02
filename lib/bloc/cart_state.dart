// ═══════════════════════════════════════════════════════════
//  cart_state.dart — حالات سلة التسوق
// ═══════════════════════════════════════════════════════════
import '../models/productModel.dart';

abstract class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

// حالة تظهر عند بدء جلب البيانات من السحاب
class CartLoading extends CartState {
  const CartLoading();
}

class CartUpdated extends CartState {
  final List<CartItem> cartItems;
  final double total;
  final int itemCount;

  CartUpdated(List<CartItem> items)
      : cartItems = List.unmodifiable(items),
        total = items.fold(0, (s, i) => s + (i.product.price * i.quantity)),
        itemCount = items.fold(0, (s, i) => s + i.quantity);

  // مقارنة الحالة لضمان تحديث الواجهة بدقة عند تغير الأسعار أو الكميات
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartUpdated &&
          cartItems.length == other.cartItems.length &&
          total == other.total;

  @override
  int get hashCode => cartItems.hashCode ^ total.hashCode;
}

// حالة في حال حدوث خطأ أثناء الاتصال بـ Firebase
class CartError extends CartState {
  final String message;
  const CartError(this.message);
}