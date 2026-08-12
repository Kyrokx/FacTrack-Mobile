import 'package:factrack_mobile/features/organization/organization_service.dart';
import 'package:flutter/material.dart';
import 'membership_model.dart';
import 'organization_model.dart';

class OrganizationProvider extends ChangeNotifier {
  Organization? _organization;
  List<Membership> _members = [];
  bool _loading = false;
  bool _membersLoading = false;
  bool _inviteCodeLoading = false;
  String? error;

  Organization? get organization => _organization;
  List<Membership> get members => _members;
  bool get loading => _loading;
  bool get membersLoading => _membersLoading;
  bool get inviteCodeLoading => _inviteCodeLoading;

  Future<void> load({bool force = false}) async {
    if (_organization != null && !force) return;

    _loading = true;
    error = null;
    notifyListeners();

    try {
      _organization = await OrganizationService.getOrganizationInfo();
    } on Exception catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  void clearError() {
    error = null;
    notifyListeners();
  }

  Future<void> loadMembers({bool force = false}) async {
    if (_members.isNotEmpty && !force) return;

    _membersLoading = true;
    error = null;
    notifyListeners();

    try {
      _members = await OrganizationService.getOrganizationMembers();
    } on Exception catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _membersLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeMember(int id) async {
    try {
      await OrganizationService.removeMember(id);
      _members.removeWhere((m) => m.id == id);
      notifyListeners();
    } on Exception catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> promoteMember(int id) async {
    try {
      await OrganizationService.promoteMember(id);
      await loadMembers(force: true);
    } on Exception catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> regenerateInviteCode() async {
    _inviteCodeLoading = true;
    notifyListeners();
    try {
      final newCode = await OrganizationService.regenerateInviteCode();
      _organization = Organization(
        id: _organization!.id,
        uid: _organization!.uid,
        name: _organization!.name,
        inviteCode: newCode,
        createdAt: _organization!.createdAt,
        members: _organization!.members,
      );
    } on Exception catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _inviteCodeLoading = false;
      notifyListeners();
    }
  }
}