import 'package:upstash_redis/upstash_redis.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RedisManager {
  static final RedisManager _instance = RedisManager._internal();

  late final Redis _client;

  factory RedisManager() => _instance;

  RedisManager._internal() {
    _client = Redis(
      url: dotenv.env['REDIS_URL'] ?? "",
      token: dotenv.env['REDIS_TOKEN'] ?? "",
    );
  }

  Future<void> setValue<T>(String key, T value, {Duration? ttl}) async {
    if (ttl != null) {
      final seconds = ttl.inSeconds;
      await _client.setex(key, seconds, value); // built-in SETEX
    } else {
      await _client.set(key, value); // normal SET
    }
  }

  /// Generic Get
  Future<T?> getValue<T>(String key) async {
    final T? res = await _client.get(key);

    if (res == null) return null;

    return res;
  }

  /// Optional delete helper
  Future<void> delete(String key) async {
    await _client.del([key]);
  }
}
