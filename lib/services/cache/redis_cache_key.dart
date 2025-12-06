enum RedisCacheKey {
  allStocks("MsStock:AllStocks"),
  singleStock("MsStock"),
  stockGraph("MsStock:StockGraph"),
  userWatchlist("UserWatchList");

  final String key;
  const RedisCacheKey(this.key);

  static String cacheAllStocks() {
    final now = DateTime.now();
    return '${RedisCacheKey.allStocks.key}:${_ddmmyyyy(now)}';
  }

  static String cacheStockByTicker(String ticker) {
    return '${RedisCacheKey.singleStock.key}:$ticker:${_ddmmyyyy(DateTime.now())}';
  }

  static String cacheTickerId(String ticker) {
    return '${RedisCacheKey.singleStock.key}:$ticker:${_ddmmyyyy(DateTime.now())}';
  }

  static String cacheUserWatchlist(String email) {
    return '${RedisCacheKey.userWatchlist.key}:$email';
  }

  static String cacheStockGraph(String ticker) {
    return '${RedisCacheKey.stockGraph.key}:$ticker:${_ddmmyyyy(DateTime.now())}';
  }

  static String _ddmmyyyy(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}'
      '${d.month.toString().padLeft(2, '0')}'
      '${d.year}';
}
