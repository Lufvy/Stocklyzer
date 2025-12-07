import 'dart:convert';

import 'package:stocklyzer/dto/stockGraphDTO.dart';
import 'package:stocklyzer/dto/stockHistoryDetailDTO.dart';
import 'package:stocklyzer/dto/watchListDTO.dart';
import 'package:stocklyzer/model/MsStock.dart';
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
        print("Cache Hit: Returning all stocks from Redis.");
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
      throw Exception(
        'Error fetching all stocks: $e',
      ); // Updated message for clarity
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
    final cacheKey = RedisCacheKey.cacheUserWatchlist(email);
    try {
      final cached = await redis.getValue<String>(cacheKey);

      if (cached != null) {
        final decoded = jsonDecode(cached) as List;
        return decoded
            .map((e) => WatchListDTO.fromJson(e as Map<String, dynamic>))
            .toList();
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

      // Only cache if the list is not empty
      if (list.isNotEmpty) {
        await redis.setValue(
          cacheKey,
          jsonEncode(list.map((e) => e.toJson()).toList()),
          ttl: cacheDuration,
        );
      }

      return list;
    } catch (e) {
      // The original code printed to console, but the request asks to match getAllStocks flow, which throws an exception.
      throw Exception('Error fetching user watchlist: $e');
    }
  }

  Future<StockGraphDTO> getStockGraph(String ticker) async {
    final cacheKey = RedisCacheKey.cacheStockGraph(ticker);

    try {
      final cachedJsonString = await redis.getValue<String>(cacheKey);

      if (cachedJsonString != null) {
        print('Cache Hit: Returning StockGraph for $ticker from Redis.');
        final Map<String, dynamic> cachedJson = jsonDecode(cachedJsonString);
        return StockGraphDTO.fromJson(cachedJson);
      }

      final response = await _client.rpc(
        'get_stock_graph_data',
        params: {'p_ticker': ticker},
      );

      final StockGraphDTO dto = StockGraphDTO.fromJson(response);

      final jsonString = jsonEncode(dto);

      await redis.setValue<String>(cacheKey, jsonString, ttl: cacheDuration);
      print('Successfully updated Redis cache for $ticker');

      return dto;
    } catch (e) {
      throw Exception('Error fetching stock graph: $e');
    }
  }

  Future<List<StockHistoryDetailDTO>> getStockHistoryDetail({
    required String ticker,
    int? resultLimit = 20,
  }) async {
    final cacheKey = RedisCacheKey.cacheStockHistoryDetail(ticker);

    try {
      final cachedJsonString = await redis.getValue<String>(cacheKey);

      if (cachedJsonString != null) {
        print(
          'Cache Hit: Returning StockHistoryDetail for $ticker from Redis.',
        );
        final List<dynamic> cachedJson = jsonDecode(cachedJsonString);
        return cachedJson
            .map((e) => StockHistoryDetailDTO.fromJson(e))
            .toList();
      }

      final response = await _client.rpc(
        'get_latest_stock_comparison',
        params: {'ticker_name': ticker, 'result_limit': resultLimit},
      );

      final List<StockHistoryDetailDTO> dtoList = (response as List)
          .map((e) => StockHistoryDetailDTO.fromJson(e))
          .toList();

      final jsonString = jsonEncode(dtoList.map((e) => e.toJson()).toList());

      await redis.setValue<String>(cacheKey, jsonString, ttl: cacheDuration);
      print('Successfully updated Redis cache for $ticker');

      return dtoList;
    } catch (e) {
      throw Exception('Error fetching stock history detail: $e');
    }
  }
}
