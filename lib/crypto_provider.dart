import 'package:flutter/material.dart';
import 'crypto_service.dart';
import 'crypto_model.dart';

class CryptoProvider with ChangeNotifier {
  List<Crypto> _cryptos = [];
  bool _isLoading = true;

  List<Crypto> get cryptos => _cryptos;
  bool get isLoading => _isLoading;

  CryptoProvider() {
    fetchCryptos();
  }

  Future<void> fetchCryptos() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Crypto> fetchedCryptos = await CryptoService().fetchCryptos();

      // Update previousPriceUsd for existing cryptos
      fetchedCryptos.forEach((fetchedCrypto) {
        final existingCryptoIndex = _cryptos.indexWhere((c) => c.symbol == fetchedCrypto.symbol);
        if (existingCryptoIndex != -1) {
          fetchedCryptos[existingCryptoIndex] = fetchedCrypto.copyWith(previousPriceUsd: _cryptos[existingCryptoIndex].priceUsd);
        }
      });

      _cryptos = fetchedCryptos;
    } catch (e) {
      // handle error
      print('Error fetching cryptos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
