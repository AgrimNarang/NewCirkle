
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class RouteGuard extends StatelessWidget {
  final Widget child;
  final String route;
  final UserService _userService = UserService();

  RouteGuard({
    super.key,
    required this.child,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = _userService.currentUser;

    if (currentUser == null) {
      return _buildAccessDenied('Please sign in to access this feature');
    }

    if (!currentUser.hasAccessToRoute(route)) {
      return _buildRestrictedAccess(currentUser);
    }

    return child;
  }

  Widget _buildAccessDenied(String message) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Access Denied'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.block,
              size: 80,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Access Denied',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestrictedAccess(AppUser user) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restricted Access'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              size: 80,
              color: Colors.orange,
            ),
            SizedBox(height: 20),
            Text(
              'Restricted Access',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'This feature is not available for ${user.isStallUser ? 'Stall' : 'Top-up'} users.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  Text(
                    'Available Features:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...user.allowedRoutes.map((route) => Text(
                    '• ${_getFeatureName(route)}',
                    style: TextStyle(fontSize: 14),
                  )).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFeatureName(String route) {
    switch (route) {
      case '/issue_new_card':
        return 'Issue New Card';
      case '/top_up':
      case '/topup':
        return 'Top Up';
      case '/check_balance_tap_card':
        return 'Check Balance';
      case '/order':
        return 'Orders';
      case '/refund':
        return 'Refund';
      case '/summary':
        return 'Summary';
      default:
        return route.replaceAll('/', '').replaceAll('_', ' ');
    }
  }
}
