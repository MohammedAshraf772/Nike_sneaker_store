import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesCubit extends Cubit<List<Map<String, dynamic>>> {
  FavoritesCubit() : super([]);

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  Future<void> loadFavorites() async {
    final snapshot =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('favorites')
            .get();

    emit(snapshot.docs.map((e) => e.data()).toList());
  }

  Future<void> toggleFavorite(Map<String, dynamic> product) async {
    final doc = _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(product['id'].toString());
    final exists = (await doc.get()).exists;

    if (exists) {
      await doc.delete();
    } else {
      await doc.set(product);
    }

    await loadFavorites();
  }

  bool isFavorite(int id) {
    return state.any((e) => e['id'] == id);
  }
}
