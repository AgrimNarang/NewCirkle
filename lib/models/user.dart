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
    // Determine user type from the userType field in the map
    UserType userType = UserType.topup; // default
    final userTypeString = map['userType']?.toString().toLowerCase();

    if (userTypeString == 'stall') {
      userType = UserType.stall;
    } else if (userTypeString == 'topup') {
      userType = UserType.topup;
    }

    return AppUser(
      id: documentId,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      userType: userType,
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
  bool get isAdmin => isStallUser; // For now, stall users have admin privileges

  List<String> get allowedRoutes {
    if (userType == UserType.stall) {
      return [
        '/order',
        '/refund',
        '/summary',
      ];
    } else {
      return [
        '/issue_new_card',
        '/top_up',
        '/topup',
        '/check_balance_tap_card',
      ];
    }
  }

  bool hasAccessToRoute(String route) {
    return allowedRoutes.contains(route);
  }
}