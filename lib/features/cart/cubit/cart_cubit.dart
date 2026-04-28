import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nike_sneaker_store/features/cart/data/models/cart_item_model.dart';
import 'package:nike_sneaker_store/features/data/models/product_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  Future<void> loadCart() async {
    final snapshot =
        await _firestore.collection('users').doc(uid).collection('cart').get();

    final items =
        snapshot.docs.map((e) => CartItemModel.fromJson(e.data())).toList();

    emit(state.copyWith(items: items));
  }

  Future<void> addToCart(ProductModel product) async {
    final doc = _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(product.id.toString());

    final snapshot = await doc.get();

    if (snapshot.exists) {
      final current = snapshot.data()!;
      await doc.update({'quantity': current['quantity'] + 1});
    } else {
      await doc.set({
        'id': product.id,
        'title': product.title,
        'image': product.image,
        'price': product.price,
        'category': product.category,
        'quantity': 1,
      });
    }

    await loadCart();
  }

  Future<void> removeFromCart(int productId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(productId.toString())
        .delete();

    await loadCart();
  }

  Future<void> incrementQuantity(int productId) async {
    final doc = _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(productId.toString());

    final data = (await doc.get()).data()!;
    await doc.update({'quantity': data['quantity'] + 1});

    await loadCart();
  }

  Future<void> decrementQuantity(int productId) async {
    final doc = _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(productId.toString());

    final data = (await doc.get()).data()!;

    if (data['quantity'] == 1) {
      await doc.delete();
    } else {
      await doc.update({'quantity': data['quantity'] - 1});
    }

    await loadCart();
  }

  Future<void> clearCart() async {
    final snapshot =
        await _firestore.collection('users').doc(uid).collection('cart').get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    emit(const CartState());
  }
}
