import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nike_sneaker_store/features/checkout/data/model/order_model.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/screens/domain/repository/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> placeOrder(OrderModel order) async {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      throw Exception('You must be logged in to place an order');
    }

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('orders')
        .add(order.toMap());
  }
}
