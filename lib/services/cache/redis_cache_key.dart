enum RedisCacheKey {
  allStocks("MsStock:AllStocks"),
  singleStock("MsStock:Stock:");

  final String key;
  const RedisCacheKey(this.key);

  static String cacheTickerId(String ticker) {
    return '${RedisCacheKey.singleStock.key}$ticker';
  }
}
