import 'package:stocklyzer/services/supabase/supabase_enum.dart';

class MsUser {
  final String email;
  final String name;
  final bool isNewUser;
  final DateTime createdAt;
  final DateTime? lastSignInAt; // nullable because not always present

  MsUser({
    required this.email,
    required this.name,
    required this.isNewUser,
    required this.createdAt,
    this.lastSignInAt,
  });

  factory MsUser.fromJson(Map<String, dynamic> json) {
    final tableUser = SupabaseTable.msUser.user;

    return MsUser(
      email: json[tableUser.email] ?? '',
      name: json[tableUser.name] ?? '',
      isNewUser: json[tableUser.isNewUser] ?? false,
      createdAt: DateTime.parse(json[tableUser.createdAt]),
      lastSignInAt: json[tableUser.lastSignInAt] != null
          ? DateTime.parse(json[tableUser.lastSignInAt])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final tableUser = SupabaseTable.msUser.user;

    return {
      tableUser.email: email,
      tableUser.name: name,
      tableUser.isNewUser: isNewUser,
      tableUser.createdAt: createdAt.toIso8601String(),
      tableUser.lastSignInAt: lastSignInAt?.toIso8601String(),
    };
  }
}
