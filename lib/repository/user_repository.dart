import 'package:stocklyzer/model/MsUser.dart';
import 'package:stocklyzer/services/supabase/supabase_enum.dart';
import 'package:stocklyzer/services/supabase/supabase_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final _client = SupabaseManager().client;

  final userTable = SupabaseTable.msUser;
  final userColumn = SupabaseTable.msUser.user;

  final userWatchlistTable = SupabaseTable.userWatchlist;
  final userWatchlistColumn = SupabaseTable.userWatchlist.watchlist;

  Future<MsUser?> getUserByEmail(String email) async {
    try {
      final data = await _client
          .from(userTable.tableName)
          .select()
          .eq(userColumn.email, email)
          .maybeSingle();

      if (data == null) return null;

      return MsUser.fromJson(data);
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  Future<bool> updateIsNewUser(bool isNewUser) async {
    final userSession = _client.auth.currentUser;
    final email = userSession?.email;
    if (email == null) return false;
    try {
      final response = await _client
          .from(userTable.tableName)
          .update({userColumn.isNewUser: isNewUser})
          .eq(userColumn.email, email)
          .select(); // return updated rows

      // If response list is not empty → update success
      return response.isNotEmpty;
    } catch (e) {
      return false; // failed
    }
  }

  Future<bool> addWatchList(List<String> watchList) async {
    final userSession = _client.auth.currentUser;
    final email = userSession?.email;
    if (email == null) return false;

    try {
      final insertData = watchList
          .map((ticker) => {'email': email, 'ticker': ticker})
          .toList();

      final response = await _client
          .from(userWatchlistTable.tableName)
          .insert(insertData)
          .select();

      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeWatchList(List<String> watchList) async {
    final userSession = _client.auth.currentUser;
    final email = userSession?.email;

    if (email == null) {
      print("❌ Error: User session or email is null.");
      return false;
    }

    if (watchList.isEmpty) {
      return true;
    }

    try {
      final response = await _client
          .from(userWatchlistTable.tableName)
          .delete()
          .eq(userWatchlistColumn.email, email)
          .inFilter(userWatchlistColumn.ticker, watchList)
          .select(); // Response will be List<Map<String, dynamic>> of deleted rows.

      if (response.isNotEmpty) {
        print(
          "✅ Successfully deleted ${response.length} stocks from watchlist for $email.",
        );
        return true;
      }

      print("✅ Deletion query executed, but 0 items were found/deleted.");
      return true;
    } on PostgrestException catch (e) {
      print("❌ Postgrest Error removing watch list: ${e.message}");
      return false;
    } catch (e) {
      print("❌ General Error removing watch list: $e");
      return false;
    }
  }
}
