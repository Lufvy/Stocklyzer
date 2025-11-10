import 'package:stocklyzer/services/supabase/SupabaseManager.dart';

class DatabaseService {
  final _client = SupabaseManager().client;

  Future<List<Map<String, dynamic>>> getStocks() async {
    final result = await _client.from('stocks').select();
    return result;
  }

  Future<void> insertStock(Map<String, dynamic> data) async {
    await _client.from('stocks').insert(data);
  }
}
