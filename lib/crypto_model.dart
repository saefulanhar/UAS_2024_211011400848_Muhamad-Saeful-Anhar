class Crypto {
  final String name;
  final String symbol;
  final double priceUsd;
  final double percentChange24h;
  final double? previousPriceUsd;

  Crypto({
    required this.name,
    required this.symbol,
    required this.priceUsd,
    required this.percentChange24h,
    this.previousPriceUsd,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      priceUsd: double.parse(json['price_usd'] ?? '0.0'),
      percentChange24h: double.parse(json['percent_change_24h'] ?? '0.0'),
      previousPriceUsd: null, // Awalnya null, akan diperbarui nanti
    );
  }

  Crypto copyWith({double? previousPriceUsd}) {
    return Crypto(
      name: this.name,
      symbol: this.symbol,
      priceUsd: this.priceUsd,
      percentChange24h: this.percentChange24h,
      previousPriceUsd: previousPriceUsd ?? this.previousPriceUsd,
    );
  }
}
