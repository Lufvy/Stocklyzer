import 'package:stocklyzer/services/supabase/supabase_enum.dart';
import 'package:stocklyzer/services/supabase/supabase_manager.dart';

class StockRepository {
  final _client = SupabaseManager().client;
  final stockTable = SupabaseTable.msStock;
}
