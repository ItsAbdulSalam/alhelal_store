import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/productsData.dart';
import '../models/productModel.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    // 1. تحميل المنتجات
    on<LoadProducts>((event, emit) {
      emit(HomeLoaded(List.from(productsData)));
    });

    // 2. البحث والفلترة حسب التصنيف
    on<FilterProducts>((event, emit) {
      final filtered = productsData.where((p) {
        final matchesSearch = p.name.toLowerCase().contains(
          event.searchTerm.toLowerCase(),
        );
        final matchesCat =
            event.category == "الكل" || p.category == event.category;
        return matchesSearch && matchesCat;
      }).toList();

      emit(HomeLoaded(filtered, selectedCategory: event.category));
    });

    // 3. الترتيب الذكي (السعر والأحدث)
    on<SortProducts>((event, emit) {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;

        // أخذ نسخة جديدة تماماً لضمان تحديث الذاكرة
        List<dynamic> sortedList = List.from(currentState.products);

        if (event.sortType == 'price_low') {
          sortedList.sort((a, b) => a.price.compareTo(b.price));
        } else if (event.sortType == 'price_high') {
          sortedList.sort((a, b) => b.price.compareTo(a.price));
        } else if (event.sortType == 'newest') {
          // ترتيب عكسي للأحدث
          sortedList = sortedList.reversed.toList();
        }

        // إرسال الحالة مع timestamp جديد لإجبار الـ UI على التحديث
        emit(
          HomeLoaded(
            sortedList,
            selectedCategory: currentState.selectedCategory,
            timestamp: DateTime.now(),
          ),
        );
      }
    });
  }
}
