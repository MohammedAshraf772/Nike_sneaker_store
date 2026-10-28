import 'dart:convert';

import 'package:http/http.dart' as http;

class ExchangeRateService {
  static const String _url = 'https://open.er-api.com/v6/latest/USD';

  Future<Map<String, double>> fetchUsdRates() async {
    final response = await http
        .get(Uri.parse(_url))
        .timeout(const Duration(seconds: 8));

    if (response.statusCode != 200) {
      throw Exception('Exchange rate request failed (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (body['result'] != 'success') {
      throw Exception('Exchange rate service returned an error');
    }

    final rates = body['rates'] as Map<String, dynamic>;

    return rates.map((code, rate) => MapEntry(code, (rate as num).toDouble()));
  }
}
