// TODO: Change this to use SupabaseTable
import 'package:stocklyzer/services/supabase/supabase_enum.dart';

class StockPrediction {
  final DateTime date;
  final String ticker;
  final double closePrediction;

  StockPrediction(this.date, this.closePrediction, this.ticker);

  /// FROM JSON
  factory StockPrediction.fromJson(Map<String, dynamic> json) {
    final tableStockPrediction = SupabaseTable.stockPrediction.prediction;

    return StockPrediction(
      DateTime.parse(json[tableStockPrediction.date]),
      (json[tableStockPrediction.closePrediction] as num).toDouble(),
      json[tableStockPrediction.ticker] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final tableStockPrediction = SupabaseTable.stockPrediction.prediction;
    return {
      tableStockPrediction.date: date
          .toIso8601String(), // Convert DateTime to String
      tableStockPrediction.ticker: ticker,
      tableStockPrediction.closePrediction: closePrediction,
    };
  }
}
