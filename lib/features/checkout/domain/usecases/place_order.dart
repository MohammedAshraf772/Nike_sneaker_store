import 'package:nike_sneaker_store/features/checkout/data/model/order_model.dart';
import '../repository/order_repository.dart';

class PlaceOrder {
  final OrderRepository repo;

  PlaceOrder(this.repo);

  Future<void> call(OrderModel order) {
    return repo.placeOrder(order);
  }
}
