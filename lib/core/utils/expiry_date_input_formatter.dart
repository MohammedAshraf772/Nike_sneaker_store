import 'package:flutter/services.dart';

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final limited =
        digitsOnly.length > 4 ? digitsOnly.substring(0, 4) : digitsOnly;

    final formatted =
        limited.length >= 3
            ? '${limited.substring(0, 2)}/${limited.substring(2)}'
            : limited;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
