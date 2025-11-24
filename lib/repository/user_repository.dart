import 'package:stocklyzer/model/MsUser.dart';
import 'package:stocklyzer/services/supabase/supabase_enum.dart';
import 'package:stocklyzer/services/supabase/supabase_manager.dart';

class UserRepository {
  final _client = SupabaseManager().client;
  final userTable = SupabaseTable.msUser;

  Future<MsUser?> getUserByEmail(String email) async {
    try {
      final data = await _client
          .from(userTable.tableName)
          .select()
          .eq(userTable.user.email, email)
          .maybeSingle();

      if (data == null) return null;

      return MsUser.fromJson(data);
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }
}
