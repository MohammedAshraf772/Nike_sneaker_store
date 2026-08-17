import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class CardScanResult {
  final String? cardNumber;
  final String? expiryDate;

  const CardScanResult({this.cardNumber, this.expiryDate});
}

class CardScannerService {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _recognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );
  Future<CardScanResult?> scanCard() async {
    final photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo == null) return null;

    final inputImage = InputImage.fromFilePath(photo.path);
    final recognizedText = await _recognizer.processImage(inputImage);

    final rawText = recognizedText.text;

    return CardScanResult(
      cardNumber: _extractCardNumber(rawText),
      expiryDate: _extractExpiryDate(rawText),
    );
  }

  String? _extractCardNumber(String text) {
    final match = RegExp(
      r'\b(?:\d[ -]?){16}\b',
    ).firstMatch(text.replaceAll(RegExp(r'[^0-9 \n]'), ' '));

    if (match == null) return null;

    return match.group(0)!.replaceAll(RegExp(r'[^0-9]'), '');
  }

  String? _extractExpiryDate(String text) {
    final match = RegExp(r'(0[1-9]|1[0-2])[\/\- ](\d{2})\b').firstMatch(text);

    if (match == null) return null;

    return '${match.group(1)}/${match.group(2)}';
  }

  void dispose() {
    _recognizer.close();
  }
}
