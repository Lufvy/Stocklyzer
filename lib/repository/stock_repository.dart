import 'dart:convert';

import 'package:stocklyzer/dto/stockGraphDTO.dart';
import 'package:stocklyzer/dto/watchListDTO.dart';
import 'package:stocklyzer/model/MsStock.dart';
import 'package:stocklyzer/model/StockPrediction.dart';
import 'package:stocklyzer/services/cache/redis_cache_key.dart';
import 'package:stocklyzer/services/cache/redis_manager.dart';
import 'package:stocklyzer/services/supabase/supabase_enum.dart';
import 'package:stocklyzer/services/supabase/supabase_manager.dart';

class StockRepository {
  final _client = SupabaseManager().client;
  final stockTable = SupabaseTable.msStock;
  final stockPredictionTable = SupabaseTable.stockPrediction;
  final redis = RedisManager();

  static const cacheDuration = Duration(hours: 24);

  Future<List<MsStock?>> getAllStocks() async {
    final allStockCacheKey = RedisCacheKey.cacheAllStocks();
    try {
      final cached = await redis.getValue<String>(allStockCacheKey);

      if (cached != null) {
        final decoded = jsonDecode(cached) as List;
        return decoded.map((e) => MsStock.fromJson(e)).toList();
      }

      final data = await _client.from(stockTable.tableName).select();

      await redis.setValue(
        allStockCacheKey,
        jsonEncode(data),
        ttl: cacheDuration,
      );

      return (data as List).map((e) => MsStock.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  Future<MsStock?> getStockByTicker(String ticker) async {
    final stockCacheKey = RedisCacheKey.cacheStockByTicker(ticker);

    try {
      final cached = await redis.getValue<String>(stockCacheKey);
      if (cached != null) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return MsStock.fromJson(decoded);
      }
      final data = await _client
          .from(stockTable.tableName)
          .select()
          .eq(stockTable.stock.ticker, ticker)
          .single();

      await redis.setValue(stockCacheKey, jsonEncode(data), ttl: cacheDuration);

      return MsStock.fromJson(data);
    } catch (e) {
      throw Exception('Error fetching stock by ticker: $e');
    }
  }

  Future<List<WatchListDTO>> getUserWatchlist(String email) async {
    try {
      final cached = await redis.getValue<String>(
        RedisCacheKey.cacheUserWatchlist(email),
      );

      if (cached != null) {
        final decoded = jsonDecode(cached) as List;
        return decoded
            .map((e) => WatchListDTO.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print("Redis read error: $e");
    }

    final response = await _client.rpc(
      'get_user_watchlist',
      params: {'p_email': email},
    );

    final rows = response as List;

    final list = rows.map((row) {
      final ticker = (row['ticker'] as String);
      final shortenedTicker = ticker.length > 3
          ? ticker.substring(0, ticker.length - 3)
          : ticker;

      return WatchListDTO(
        ticker: shortenedTicker,
        name: row['name'],
        lastPrice: (row['last_price'] as num?)?.toDouble() ?? 0.0,
        predictedPrice: (row['predicted_price'] as num?)?.toDouble() ?? 0.0,
      );
    }).toList();

    if (list.isEmpty) {
      return [];
    }

    try {
      await redis.setValue(
        RedisCacheKey.cacheUserWatchlist(email),
        jsonEncode(list.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      print("Redis write error: $e");
    }

    return list;
  }

  Future<StockGraphDTO> getStockGraph(String ticker) async {
    final cacheKey = RedisCacheKey.cacheStockGraph(ticker);

    try {
      final cachedJsonString = await redis.getValue<String>(cacheKey);

      if (cachedJsonString != null && cachedJsonString.isNotEmpty) {
        print('Cache Hit: Returning StockGraph for $ticker from Redis.');
        final Map<String, dynamic> cachedJson = jsonDecode(cachedJsonString);
        return StockGraphDTO.fromJson(cachedJson);
      }
    } catch (e) {
      print('Redis read error for $ticker: $e');
    }

    final response = await _client.rpc(
      'get_stock_graph_data',
      params: {'p_ticker': ticker},
    );

    final StockGraphDTO dto = StockGraphDTO.fromJson(response);

    try {
      final jsonString = jsonEncode(dto);

      await redis.setValue<String>(cacheKey, jsonString, ttl: cacheDuration);
      print('Successfully updated Redis cache for $ticker');
    } catch (e) {
      print('Redis write error for $ticker: $e');
    }
    return dto;
  }

  // Future<StockPrediction> getDetailStockPrediction(String ticker) async {
  //   try {
  //     final data = await _client
  //         .from(stockPredictionTable.tableName)
  //         .select()
  //         .eq(stockPredictionTable.prediction.ticker, ticker)
  //         .order(stockPredictionTable.prediction.date, ascending: false)
  //         .limit(20);

  //     return StockPrediction.fromJson(data);
  //   } catch (e) {
  //     throw Exception('Error fetching stock prediction by ticker: $e');
  //   }
  // }
}
