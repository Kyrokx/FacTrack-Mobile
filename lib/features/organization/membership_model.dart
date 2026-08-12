class Membership {
  final int id;
  final String username;
  final String role;
  final String joinedAt;

  Membership({
    required this.id,
    required this.username,
    required this.role,
    required this.joinedAt,
  });

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      id: json['id'],
      username: json['username'],
      role: json['role'],
      joinedAt: json['joined_at'],
    );
  }
}