import 'package:nike_sneaker_store/features/checkout/data/models/order_model.dart';

abstract class OrderRepository {
  Future<void> placeOrder(OrderModel order);
}
