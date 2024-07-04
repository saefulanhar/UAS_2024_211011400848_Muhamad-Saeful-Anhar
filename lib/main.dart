import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'crypto_provider.dart';
import 'crypto_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CryptoProvider(),
      child: MaterialApp(
        home: MyApp(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harga Crypto'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Provider.of<CryptoProvider>(context, listen: false).fetchCryptos();
            },
          ),
        ],
      ),
      body: Consumer<CryptoProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: provider.cryptos.length,
              itemBuilder: (context, index) {
                final crypto = provider.cryptos[index];
                final priceChangeIndicator = _buildPriceChangeIndicator(crypto);

                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: Image.asset(
                      'assets/${crypto.symbol.toLowerCase()}.png', // Ubah sesuai dengan nama file ikon Anda
                      width: 48.0,
                      height: 48.0,
                    ),
                    title: Text(crypto.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(crypto.symbol),
                    trailing: Container(
                      width: 120.0, // Lebar kontainer trailing
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('\$${crypto.priceUsd.toStringAsFixed(2)}', style: TextStyle(fontSize: 16.0)),
                          Text(
                            '${crypto.percentChange24h}%',
                            style: TextStyle(
                              color: crypto.percentChange24h > 0 ? Colors.green : Colors.red,
                            ),
                          ),
                          if (priceChangeIndicator != null) priceChangeIndicator,
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget? _buildPriceChangeIndicator(Crypto crypto) {
    if (crypto.previousPriceUsd == null) return null;

    final priceChange = crypto.priceUsd - crypto.previousPriceUsd!;
    final priceChangeText = priceChange > 0 ? '+${priceChange.toStringAsFixed(2)}' : priceChange.toStringAsFixed(2);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          priceChange > 0 ? Icons.arrow_upward : Icons.arrow_downward,
          color: priceChange > 0 ? Colors.green : Colors.red,
        ),
        SizedBox(width: 4.0),
        Text(
          priceChangeText,
          style: TextStyle(
            color: priceChange > 0 ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
