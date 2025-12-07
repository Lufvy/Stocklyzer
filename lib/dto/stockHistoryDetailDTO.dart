class StockHistoryDetailDTO {
  final DateTime date;
  final double close;
  final double predictedClose;
  final double accuracy;

  StockHistoryDetailDTO({
    required this.date,
    required this.close,
    required this.predictedClose,
  }) : accuracy = 1 - (predictedClose - close).abs() / close;

  /// FROM JSON (cache)
  factory StockHistoryDetailDTO.fromJson(Map<String, dynamic> json) {
    return StockHistoryDetailDTO(
      date: DateTime.parse(json['date']),
      close: (json['close'] as num).toDouble(),
      predictedClose: (json['predicted_close'] as num).toDouble(),
    );
  }

  /// TO JSON (cache)
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'close': close,
      'predicted_close': predictedClose,
    };
  }
}
