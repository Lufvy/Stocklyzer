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
    final tableStock = SupabaseTable.msStock.stock;

    return MsStock(
      json[tableStock.ticker] ?? '',
      json[tableStock.name] ?? '',
      json[tableStock.sectorEN] ?? '',
      json[tableStock.subsectorEN] ?? '',
      json[tableStock.descriptionEN] ?? '',
      json[tableStock.sectorID],
      json[tableStock.subsectorID],
      json[tableStock.descriptionID],
      (json[tableStock.accuracy] ?? 0).toDouble(),
      (json[tableStock.nInference] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final tableStock = SupabaseTable.msStock.stock;

    return {
      tableStock.ticker: ticker,
      tableStock.name: name,
      tableStock.sectorEN: sector,
      tableStock.subsectorEN: subsector,
      tableStock.descriptionEN: description,
      tableStock.sectorID: sectorID,
      tableStock.subsectorID: subsectorID,
      tableStock.descriptionID: descriptionID,
      tableStock.accuracy: accuracy,
      tableStock.nInference: nInference,
    };
  }
}
