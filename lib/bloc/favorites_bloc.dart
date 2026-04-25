// ═══════════════════════════════════════════════════════════
//  favorites_event.dart
// ═══════════════════════════════════════════════════════════
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/productModel.dart';

abstract class FavoritesEvent {
  const FavoritesEvent();
}

class ToggleFavorite extends FavoritesEvent {
  final Product product;
  const ToggleFavorite({required this.product});
}

// ═══════════════════════════════════════════════════════════
//  favorites_state.dart
// ═══════════════════════════════════════════════════════════

abstract class FavoritesState {
  const FavoritesState();
}

class FavoritesUpdated extends FavoritesState {
  final List<Product> items;
  final Set<String> ids; // للبحث السريع O(1)

  FavoritesUpdated(List<Product> list)
      : items = List.unmodifiable(list),
        ids = list.map((p) => p.id).toSet();

  bool isFavorite(String id) => ids.contains(id);

  const FavoritesUpdated.empty()
      : items = const [],
        ids = const {};
}

// ═══════════════════════════════════════════════════════════
//  favorites_bloc.dart
// ═══════════════════════════════════════════════════════════


class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final List<Product> _items = [];

  FavoritesBloc() : super(const FavoritesUpdated.empty()) {
    on<ToggleFavorite>(_onToggle);
  }

  void _onToggle(ToggleFavorite e, Emitter<FavoritesState> emit) {
    final exists = _items.any((p) => p.id == e.product.id);
    if (exists) {
      _items.removeWhere((p) => p.id == e.product.id);
    } else {
      _items.add(e.product);
    }
    emit(FavoritesUpdated(List.from(_items)));
  }
}
