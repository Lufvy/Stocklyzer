import 'package:stocklyzer/model/StockData.dart';
import 'package:stocklyzer/model/StockPrediction.dart';

// TODO: Adjust this after implementing this in stockRepository
class StockGraphDTO {
  final String ticker;
  final double totalAccuracy;

  // List of past 10 days of real stock data
  final List<StockData> stockData;

  // List of stock predictions for next 1-5 days
  final List<StockPrediction> stockPrediction;

  StockGraphDTO({
    required this.ticker,
    required this.totalAccuracy,
    required this.stockData,
    required this.stockPrediction,
  });

  /// FROM JSON
  factory StockGraphDTO.fromJson(Map<String, dynamic> json) {
    return StockGraphDTO(
      ticker: json['ticker'] ?? '',
      // 1. FIXED: Cast num to String for totalAccuracy
      totalAccuracy: (json['totalAccuracy'] as num? ?? 0.0).toDouble(),
      stockData: (json['stockData'] as List<dynamic>? ?? [])
          // 2. FIXED: Explicitly cast 'e' to Map<String, dynamic>
          .map((e) => StockData.fromJson(e as Map<String, dynamic>))
          .toList(),
      stockPrediction: (json['stockPrediction'] as List<dynamic>? ?? [])
          // 2. FIXED: Explicitly cast 'e' to Map<String, dynamic>
          .map((e) => StockPrediction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticker': ticker,
      'totalAccuracy': totalAccuracy,
      // Map nested lists, calling toJson() on each nested object
      'stockData': stockData.map((e) => e.toJson()).toList(),
      'stockPrediction': stockPrediction.map((e) => e.toJson()).toList(),
    };
  }
}

class StockGraphHoverPoint {
  final DateTime date;
  final double closePrice;
  final double? predictedClosePrice;
  final double? accuracy;
  StockGraphHoverPoint({
    required this.date,
    required this.closePrice,
    required this.predictedClosePrice,
  }) : accuracy = (predictedClosePrice != null
           ? 1 - ((predictedClosePrice - closePrice).abs() / closePrice)
           : null);
}
