import 'package:factrack_mobile/features/organization/membership_model.dart';

class Organization {
  final int id;
  final String uid;
  final String name;
  final String inviteCode;
  final String createdAt;
  final List<Membership> members;

  Organization({
    required this.id,
    required this.uid,
    required this.name,
    required this.inviteCode,
    required this.createdAt,
    required this.members,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      uid: json['uid'],
      name: json['name'],
      inviteCode: json['invite_code'],
      createdAt: json['created_at'],
      members: (json['members'] as List)
          .map((e) => Membership.fromJson(e))
          .toList(),
    );
  }
}