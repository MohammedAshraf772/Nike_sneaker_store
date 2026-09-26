class OrderLineItem {
  final String productId;
  final String productTitle;
  final String productImage;
  final double unitPrice;
  final int quantity;

  const OrderLineItem({
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.unitPrice,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productTitle': productTitle,
      'productImage': productImage,
      'unitPrice': unitPrice,
      'quantity': quantity,
    };
  }
}

class OrderModel {
  final List<OrderLineItem> items;
  final double subtotal;
  final double shippingFee;
  final double codFee;
  final double totalPrice;
  final String paymentMethod;
  final String cardHolderName;
  final String last4;
  final String status;
  final DateTime createdAt;

  const OrderModel({
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.codFee,
    required this.totalPrice,
    required this.paymentMethod,
    required this.cardHolderName,
    required this.last4,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'codFee': codFee,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'cardHolderName': cardHolderName,
      'last4': last4,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
