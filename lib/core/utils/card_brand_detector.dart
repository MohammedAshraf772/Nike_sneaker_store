enum CardBrand { visa, mastercard, amex, unknown }

extension CardBrandLabel on CardBrand {
  String get label {
    switch (this) {
      case CardBrand.visa:
        return 'Visa';
      case CardBrand.mastercard:
        return 'Mastercard';
      case CardBrand.amex:
        return 'American Express';
      case CardBrand.unknown:
        return '';
    }
  }
}

class CardBrandDetector {
  CardBrandDetector._();

  static CardBrand detect(String cardNumber) {
    final digits = cardNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) return CardBrand.unknown;

    if (digits.startsWith('4')) {
      return CardBrand.visa;
    }

    if (RegExp(r'^5[1-5]').hasMatch(digits) ||
        RegExp(r'^2(2[2-9]|[3-6]\d|7[01]|720)').hasMatch(digits)) {
      return CardBrand.mastercard;
    }

    if (RegExp(r'^3[47]').hasMatch(digits)) {
      return CardBrand.amex;
    }

    return CardBrand.unknown;
  }
}
