part of 'home_bloc.dart';

abstract class HomeEvent {}

class LoadProducts extends HomeEvent {}

class FilterProducts extends HomeEvent {
  final String searchTerm;
  final String category;
  FilterProducts(this.searchTerm, this.category);
}

// حدث الترتيب الجديد
class SortProducts extends HomeEvent {
  final String sortType; // 'price_low', 'price_high', 'newest'
  SortProducts(this.sortType);
}
