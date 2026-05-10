import 'package:flutter/foundation.dart';

@immutable
abstract class FavoritesEvent {}

class ToggleFavorite extends FavoritesEvent {
  final dynamic product; // المنتج الذي نريد إضافته أو حذفه

  ToggleFavorite({required this.product});
  
}
