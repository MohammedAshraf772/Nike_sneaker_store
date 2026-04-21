import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/features/home/data/repo/product_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final ProductRepository _repo;

  SearchCubit(this._repo) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final all = await _repo.getProducts();
      final results =
          all
              .where(
                (p) =>
                    p.category.toLowerCase().contains(query.toLowerCase()) ||
                    p.category.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();

      emit(SearchLoaded(results: results, query: query));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void clear() => emit(SearchInitial());
}
