// TODO: Change this to use SupabaseTable
import 'package:stocklyzer/services/supabase/supabase_enum.dart';

class StockData {
  final DateTime date;
  final String ticker;
  final double close;

  StockData(this.date, this.close, this.ticker);

  factory StockData.fromJson(Map<String, dynamic> json) {
    final tableStockData = SupabaseTable.stockData.stockDataCols;

    return StockData(
      DateTime.parse(json[tableStockData.date]),
      (json[tableStockData.close] as num).toDouble(),
      json[tableStockData.ticker] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final tableStockData = SupabaseTable.stockData.stockDataCols;
    return {
      tableStockData.date: date.toIso8601String(), // Convert DateTime to String
      tableStockData.ticker: ticker,
      tableStockData.close: close,
    };
  }
}
