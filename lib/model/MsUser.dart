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
    final tableUser = SupabaseTable.msUser;

    return MsUser(
      email: json[tableUser.user.email] ?? '',
      name: json[tableUser.user.name] ?? '',
      isNewUser: json[tableUser.user.isNewUser] ?? false,
      createdAt: DateTime.parse(json[tableUser.user.createdAt]),
      lastSignInAt: json[tableUser.user.lastSignInAt] != null
          ? DateTime.parse(json[tableUser.user.lastSignInAt])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final tableUser = SupabaseTable.msUser;

    return {
      tableUser.user.email: email,
      tableUser.user.name: name,
      tableUser.user.isNewUser: isNewUser,
      tableUser.user.createdAt: createdAt.toIso8601String(),
      tableUser.user.lastSignInAt: lastSignInAt?.toIso8601String(),
    };
  }
}
