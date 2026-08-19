import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScannedCardData {
  final String? cardNumber;
  final String? expiryDate;

  const ScannedCardData({this.cardNumber, this.expiryDate});

  bool get isEmpty => cardNumber == null && expiryDate == null;
}

class CardScannerService {
  final TextRecognizer _recognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  Future<ScannedCardData> scanImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognizedText = await _recognizer.processImage(inputImage);

    return ScannedCardData(
      cardNumber: _extractCardNumber(recognizedText.text),
      expiryDate: _extractExpiryDate(recognizedText.text),
    );
  }

  String? _extractCardNumber(String text) {
    final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
    final match = RegExp(r'\d{16}').firstMatch(digitsOnly);
    return match?.group(0);
  }

  String? _extractExpiryDate(String text) {
    final match = RegExp(r'(0[1-9]|1[0-2])\s*/\s*\d{2}\b').firstMatch(text);
    return match?.group(0)?.replaceAll(RegExp(r'\s+'), '');
  }

  void dispose() {
    _recognizer.close();
  }
}
