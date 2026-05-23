import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/data/models/product_model.dart';

class FavoritesCubit extends Cubit<List<ProductModel>> {
  FavoritesCubit() : super([]);

  void toggleFavorite(ProductModel product) {
    final favorites = List<ProductModel>.from(state);

    if (favorites.contains(product)) {
      favorites.remove(product);
    } else {
      favorites.add(product);
    }

    emit(favorites);
  }

  bool isFavorite(ProductModel product) {
    return state.contains(product);
  }
}
