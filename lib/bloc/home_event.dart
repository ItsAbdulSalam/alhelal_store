part of 'home_bloc.dart';
abstract class HomeEvent {}
class LoadProducts extends HomeEvent {}
class FilterProducts extends HomeEvent {
  final String searchTerm;
  final String category;
  FilterProducts(this.searchTerm, this.category);
}