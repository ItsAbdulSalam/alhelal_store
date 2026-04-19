import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorites_state.dart';
import 'favorites_event.dart'; // استدعاء الملف الذي أنشأناه للتو
import '../../data/favorites_data.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesUpdated(List.from(globalFavoritesList))) {
    on<ToggleFavorite>((event, emit) {
      // نستخدم event.product للوصول للمنتج الممرر
      final bool exists = globalFavoritesList.any(
        (p) => p.id == event.product.id,
      );

      if (exists) {
        globalFavoritesList.removeWhere((p) => p.id == event.product.id);
      } else {
        globalFavoritesList.add(event.product);
      }

      emit(FavoritesUpdated(List.from(globalFavoritesList)));
    });
  }
}
 