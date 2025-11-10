import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseManager {
  static final SupabaseManager _instance = SupabaseManager._internal();
  late final SupabaseClient client;

  factory SupabaseManager() {
    return _instance;
  }

  SupabaseManager._internal() {
    client = Supabase.instance.client;
  }
}
