part of 'home_bloc.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<dynamic> products;
  final String selectedCategory;
  // أضفنا التايم ستامب لإجبار الواجهة على التحديث عند الترتيب
  final DateTime? timestamp;

  HomeLoaded(this.products, {this.selectedCategory = "الكل", this.timestamp});
}
