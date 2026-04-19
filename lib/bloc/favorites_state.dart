abstract class FavoritesState {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {}

class FavoritesUpdated extends FavoritesState {
  final List<dynamic> favoritesList;
  const FavoritesUpdated(this.favoritesList);
}