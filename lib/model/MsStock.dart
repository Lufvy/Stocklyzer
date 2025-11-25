import 'package:stocklyzer/services/supabase/supabase_enum.dart';

class MsStock {
  String ticker;
  final String name;

  final String sector;
  final String subsector;
  final String description;

  final String? sectorID;
  final String? subsectorID;
  final String? descriptionID;

  final double accuracy;
  final double nInference;

  MsStock(
    this.ticker,
    this.name,
    this.sector,
    this.subsector,
    this.description,
    this.sectorID,
    this.subsectorID,
    this.descriptionID,
    this.accuracy,
    this.nInference,
  );

  factory MsStock.fromJson(Map<String, dynamic> json) {
    final tableStock = SupabaseTable.msStock;

    return MsStock(
      json[tableStock.stock.ticker] ?? '',
      json[tableStock.stock.name] ?? '',
      json[tableStock.stock.sectorEN] ?? '',
      json[tableStock.stock.subsectorEN] ?? '',
      json[tableStock.stock.descriptionEN] ?? '',
      json[tableStock.stock.sectorID],
      json[tableStock.stock.subsectorID],
      json[tableStock.stock.descriptionID],
      (json[tableStock.stock.accuracy] ?? 0).toDouble(),
      (json[tableStock.stock.nInference] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final tableStock = SupabaseTable.msStock;

    return {
      tableStock.stock.ticker: ticker,
      tableStock.stock.name: name,
      tableStock.stock.sectorEN: sector,
      tableStock.stock.subsectorEN: subsector,
      tableStock.stock.descriptionEN: description,
      tableStock.stock.sectorID: sectorID,
      tableStock.stock.subsectorID: subsectorID,
      tableStock.stock.descriptionID: descriptionID,
      tableStock.stock.accuracy: accuracy,
      tableStock.stock.nInference: nInference,
    };
  }
}
