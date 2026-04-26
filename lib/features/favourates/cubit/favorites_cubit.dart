import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesCubit extends Cubit<List<Map<String, dynamic>>> {
  FavoritesCubit() : super([]);

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get uid => _auth.currentUser?.uid;

  Future<void> loadFavorites() async {
    if (uid == null) return;

    final snapshot =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('favorites')
            .get();

    final items =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return {'docId': doc.id, ...data};
        }).toList();

    emit(items);
  }

  bool isFavorite(String title) {
    return state.any((item) => item['title'] == title);
  }

  Future<void> toggleFavorite(Map<String, dynamic> product) async {
    if (uid == null) return;

    final collection = _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites');

    final snapshot =
        await collection.where('title', isEqualTo: product['title']).get();

    if (snapshot.docs.isNotEmpty) {
      await snapshot.docs.first.reference.delete();
    } else {
      await collection.add(product);
    }

    loadFavorites();
  }
}
