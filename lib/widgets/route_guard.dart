import 'package:flutter/material.dart';
import '../services/user_service.dart';

class RouteGuard extends StatelessWidget {
  final Widget child;
  final String route;

  const RouteGuard({
    Key? key,
    required this.child,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    
    // Check if user is signed in
    if (!userService.isSignedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Check if user has access to this route
    // Dashboard is accessible to all authenticated users
    if (route == '/dashboard' || !userService.hasAccessToRoute(route)) {
      if (route != '/dashboard') {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Access Denied'),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  size: 80,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 20),
                Text(
                  'Access Denied',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'You don\'t have permission to access this feature.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context, 
                      '/dashboard', 
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Go to Dashboard'),
                ),
              ],
            ),
          ),
        );
      }
    }

    return child;
  }
}
