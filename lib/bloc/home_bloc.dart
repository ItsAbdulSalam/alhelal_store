import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/productsData.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    on<LoadProducts>((event, emit) {
      emit(HomeLoaded(productsData));
    });

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
  }
}
