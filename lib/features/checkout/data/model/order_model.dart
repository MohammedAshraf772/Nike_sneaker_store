class OrderModel {
  final String productId;
  final String productTitle;
  final String productImage;
  final double unitPrice;
  final int quantity;
  final double totalPrice;
  final String cardHolderName;
  final String last4;
  final String status;
  final DateTime createdAt;

  const OrderModel({
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
    required this.cardHolderName,
    required this.last4,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productTitle': productTitle,
      'productImage': productImage,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'cardHolderName': cardHolderName,
      'last4': last4,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
