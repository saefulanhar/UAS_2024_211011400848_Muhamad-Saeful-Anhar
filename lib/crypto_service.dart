import 'dart:convert';
import 'package:http/http.dart' as http;
import 'crypto_model.dart';

class CryptoService {
  static const String url = 'https://api.coinlore.net/api/tickers/';

  Future<List<Crypto>> fetchCryptos() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Crypto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
