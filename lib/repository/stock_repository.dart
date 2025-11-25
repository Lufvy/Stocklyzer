import 'dart:convert';

import 'package:stocklyzer/model/MsStock.dart';
import 'package:stocklyzer/services/cache/redis_cache_key.dart';
import 'package:stocklyzer/services/cache/redis_manager.dart';
import 'package:stocklyzer/services/supabase/supabase_enum.dart';
import 'package:stocklyzer/services/supabase/supabase_manager.dart';

class StockRepository {
  final _client = SupabaseManager().client;
  final stockTable = SupabaseTable.msStock;
  final redis = RedisManager();

  final allStockCacheKey = RedisCacheKey.allStocks.key;
  static const cacheDuration = Duration(hours: 12);

  Future<List<MsStock?>> getAllStocks() async {
    try {
      // 1. Check cache first
      final cached = await redis.getValue<String>(allStockCacheKey);

      if (cached != null) {
        print("✔ Cache hit → Returning Redis stocks");
        final decoded = jsonDecode(cached) as List;
        return decoded.map((e) => MsStock.fromJson(e)).toList();
      }

      final data = await _client.from(stockTable.tableName).select();

      await redis.setValue(
        allStockCacheKey,
        jsonEncode(data),
        ttl: cacheDuration,
      );

      if (data == null) return [];
      return (data as List).map((e) => MsStock.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }
}
