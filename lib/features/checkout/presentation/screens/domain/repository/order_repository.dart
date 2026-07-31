import 'package:nike_sneaker_store/features/checkout/data/model/order_model.dart';

abstract class OrderRepository {
  Future<void> placeOrder(OrderModel order);
}
