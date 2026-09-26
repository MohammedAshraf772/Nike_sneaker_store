enum PaymentMethod { visa, cashOnDelivery }

extension PaymentMethodLabel on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.visa:
        return 'Credit / Debit Card';
      case PaymentMethod.cashOnDelivery:
        return 'Cash on Delivery';
    }
  }
}
