import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nike_sneaker_store/features/cart/data/models/cart_item_model.dart';
import 'package:nike_sneaker_store/features/home/data/models/product_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String get uid => _auth.currentUser!.uid;

  Future<void> _handleError(dynamic e) async =>
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));

  Future<void> loadCart() async {
    emit(state.copyWith(isLoading: true));
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('cart')
              .get();
      final items =
          snapshot.docs.map((e) => CartItemModel.fromJson(e.data())).toList();
      emit(state.copyWith(items: items, isLoading: false));
    } catch (e) {
      await _handleError(e);
    }
  }

  Future<void> addToCart(ProductModel product) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(product.id.toString());
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.update({'quantity': doc.data()!['quantity'] + 1});
      } else {
        await docRef.set({
          'id': product.id,
          'title': product.title,
          'image': product.image,
          'price': product.price,
          'category': product.category,
          'quantity': 1,
        });
      }
      await loadCart();
    } catch (e) {
      await _handleError(e);
    }
  }

  Future<void> removeFromCart(int productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(productId.toString())
          .delete();
      await loadCart();
    } catch (e) {
      await _handleError(e);
    }
  }

  Future<void> incrementQuantity(int productId) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(productId.toString());
      final data = (await docRef.get()).data()!;
      await docRef.update({'quantity': data['quantity'] + 1});
      await loadCart();
    } catch (e) {
      await _handleError(e);
    }
  }

  Future<void> decrementQuantity(int productId) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(productId.toString());
      final data = (await docRef.get()).data()!;
      if (data['quantity'] <= 1)
        await docRef.delete();
      else
        await docRef.update({'quantity': data['quantity'] - 1});
      await loadCart();
    } catch (e) {
      await _handleError(e);
    }
  }

  Future<void> clearCart() async {
    try {
      final batch = _firestore.batch();
      final snapshot =
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('cart')
              .get();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      emit(const CartState());
    } catch (e) {
      await _handleError(e);
    }
  }
}
