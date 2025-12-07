enum SupabaseTable {
  msUser,
  msStock,
  stockData,
  stockPrediction,
  userWatchlist;

  String get tableName {
    switch (this) {
      case SupabaseTable.msUser:
        return "MsUser";
      case SupabaseTable.msStock:
        return "MsStock";
      case SupabaseTable.stockData:
        return "StockData";
      case SupabaseTable.stockPrediction:
        return "StockPrediction";
      case SupabaseTable.userWatchlist:
        return "UserWatchList";
    }
  }

  MsUserColumns get user {
    return MsUserColumns();
  }

  MsStockColumns get stock {
    return MsStockColumns();
  }

  StockDataColumns get stockDataCols {
    return StockDataColumns();
  }

  StockPredictionColumns get prediction {
    return StockPredictionColumns();
  }

  UserWatchListColumns get watchlist {
    return UserWatchListColumns();
  }
}

// ─────────────────────────────────────────────
// Column Classes
// ─────────────────────────────────────────────

class MsUserColumns {
  String get email => "email";
  String get name => "name";
  String get isNewUser => "isNewUser";
  String get createdAt => "created_at";
  String get lastSignInAt => "last_sign_in_at";
}

class MsStockColumns {
  String get ticker => "ticker";
  String get name => "name";
  String get sectorEN => "sectorEN";
  String get subsectorEN => "subSectorEN";
  String get descriptionEN => "descriptionEN";
  String get sectorID => "sectorID";
  String get subsectorID => "subSectorID";
  String get descriptionID => "descriptionID";
  String get accuracy => "accuracy";
  String get nInference => "n_inference";
}

class StockDataColumns {
  String get date => "date";
  String get ticker => "ticker";
  String get close => "close";
  String get open => "open";
  String get high => "high";
  String get low => "low";
  String get volume => "volume";
  String get createdAt => "created_at";
}

class StockPredictionColumns {
  String get date => "date";
  String get ticker => "ticker";
  String get closePrediction => "closePrediction";
  String get createdAt => "created_at";
}

class UserWatchListColumns {
  String get ticker => "ticker";
  String get email => "email";
}
