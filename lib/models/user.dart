import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType {
  stall,
  topup
}

class AppUser {
  final String id;
  final String email;
  final String name;
  final UserType userType;
  final DateTime createdAt;
  final bool isActive;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.userType,
    required this.createdAt,
    this.isActive = true,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String documentId) {
    return AppUser(
      id: documentId,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      userType: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${map['userType']}',
        orElse: () => UserType.topup,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'userType': userType.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }

  bool get isStallUser => userType == UserType.stall;
  bool get isTopupUser => userType == UserType.topup;

  List<String> get allowedRoutes {
    if (isStallUser) {
      return [
        '/issue_new_card',
        '/topup',
        '/check_balance_tap_card',
        '/refund',
        '/summary',
      ];
    } else {
      return [
        '/issue_new_card',
        '/topup',
        '/check_balance_tap_card',
      ];
    }
  }
}