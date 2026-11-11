import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/data/models/product_model.dart';

class FavoritesCubit extends Cubit<List<ProductModel>> {
  FavoritesCubit() : super([]) {
    _authSubscription = _auth.authStateChanges().listen(_onAuthChanged);
  }

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authSubscription;

  CollectionReference<Map<String, dynamic>> get _favoritesRef => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('favorites');

  void _onAuthChanged(User? user) {
    if (user == null) {
      emit([]);
    } else {
      loadFavorites();
    }
  }

  Future<void> loadFavorites() async {
    try {
      final snapshot = await _favoritesRef.get();
      emit(
        snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList(),
      );
    } catch (_) {
      return;
    }
  }

  Future<void> toggleFavorite(ProductModel product) async {
    if (_auth.currentUser == null) return;

    final wasFavorite = isFavorite(product);
    final updated = List<ProductModel>.from(state);

    if (wasFavorite) {
      updated.remove(product);
    } else {
      updated.add(product);
    }
    emit(updated);

    try {
      final doc = _favoritesRef.doc(product.id.toString());
      if (wasFavorite) {
        await doc.delete();
      } else {
        await doc.set(product.toMap());
      }
    } catch (_) {
      await loadFavorites();
    }
  }

  bool isFavorite(ProductModel product) {
    return state.contains(product);
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
