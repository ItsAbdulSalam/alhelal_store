part of 'home_bloc.dart';
abstract class HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final List<dynamic> products;
  final String selectedCategory;
  HomeLoaded(this.products, {this.selectedCategory = "الكل"});
}