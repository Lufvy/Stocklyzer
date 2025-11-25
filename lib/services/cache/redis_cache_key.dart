enum RedisCacheKey {
  allStocks("MsStock:AllStocks");

  final String key;
  const RedisCacheKey(this.key);
}
