class WatchListDTO {
  final String ticker;
  final String name;

  final double lastPrice;
  final double predictedPrice;

  WatchListDTO({
    required this.ticker,
    required this.name,
    required this.lastPrice,
    required this.predictedPrice,
  });

  /// FROM JSON (cache)
  factory WatchListDTO.fromJson(Map<String, dynamic> json) {
    return WatchListDTO(
      ticker: json['ticker'] ?? '',
      name: json['name'] ?? '',
      lastPrice: (json['last_price'] as double?) ?? 0.0,
      predictedPrice: (json['predicted_price'] as double?) ?? 0.0,
    );
  }

  /// TO JSON (cache)
  Map<String, dynamic> toJson() {
    return {
      'ticker': ticker,
      'name': name,
      'last_price': lastPrice,
      'predicted_price': predictedPrice,
    };
  }
}
