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
    return MsUser(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      isNewUser: json['isNewUser'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      lastSignInAt: json['last_sign_in_at'] != null
          ? DateTime.parse(json['last_sign_in_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'isNewUser': isNewUser,
      'created_at': createdAt.toIso8601String(),
      'last_sign_in_at': lastSignInAt?.toIso8601String(),
    };
  }
}
