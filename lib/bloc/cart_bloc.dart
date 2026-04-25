// ═══════════════════════════════════════════════════════════
//  cart_bloc.dart  — pure BLoC, no global state
// ═══════════════════════════════════════════════════════════
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/productModel.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<CartItem> _items = [];

  CartBloc() : super(const CartInitial()) {
    on<AddToCart>(_onAdd);
    on<UpdateQuantity>(_onUpdate);
    on<RemoveFromCart>(_onRemove);
    on<ClearCart>(_onClear);
  }

  List<CartItem> get items => List.unmodifiable(_items);

  void _onAdd(AddToCart e, Emitter<CartState> emit) {
    final idx = _items.indexWhere((i) => i.product.id == e.product.id);
    if (idx != -1) {
      _items[idx] = CartItem(
        product: _items[idx].product,
        quantity: _items[idx].quantity + e.quantity,
      );
    } else {
      _items.add(CartItem(product: e.product, quantity: e.quantity));
    }
    emit(CartUpdated(List.from(_items)));
  }

  void _onUpdate(UpdateQuantity e, Emitter<CartState> emit) {
    final idx = _items.indexWhere((i) => i.product.id == e.product.id);
    if (idx == -1) return;

    if (e.isIncrement) {
      _items[idx] = CartItem(
        product: _items[idx].product,
        quantity: _items[idx].quantity + 1,
      );
    } else if (_items[idx].quantity > 1) {
      _items[idx] = CartItem(
        product: _items[idx].product,
        quantity: _items[idx].quantity - 1,
      );
    } else {
      _items.removeAt(idx);
    }
    emit(CartUpdated(List.from(_items)));
  }

  void _onRemove(RemoveFromCart e, Emitter<CartState> emit) {
    _items.removeWhere((i) => i.product.id == e.product.id);
    emit(CartUpdated(List.from(_items)));
  }

  void _onClear(ClearCart e, Emitter<CartState> emit) {
    _items.clear();
    emit(CartUpdated(const []));
  }
}
