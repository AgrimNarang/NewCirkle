
import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../models/user.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final UserService _userService = UserService();
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _userService.currentUser;
  }

  void _signOut() {
    _userService.clearCurrentUser();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;
    final isTablet = screenSize.width >= 600 && screenSize.width < 1024;

    // Determine grid cross axis count based on screen size
    int crossAxisCount = 2;
    if (isTablet) {
      crossAxisCount = 3;
    } else if (!isMobile) {
      crossAxisCount = 4;
    }

    // Get all menu items with permission info
    List<Map<String, dynamic>> menuItems = _getAllMenuItems();

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Cirkle POS Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // User Info Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          currentUser?.isStallUser == true ? Icons.store : Icons.account_balance_wallet,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, ${currentUser?.name ?? 'User'}',
                              style: TextStyle(
                                fontSize: isMobile ? 18 : 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                currentUser?.isStallUser == true ? 'Stall User' : 'Top-up User',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Menu Grid
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: isMobile ? 1.1 : 1.2,
                    crossAxisSpacing: isMobile ? 12 : 16,
                    mainAxisSpacing: isMobile ? 12 : 16,
                  ),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return _buildMenuCard(
                      item['title'],
                      item['icon'],
                      item['route'],
                      item['color'],
                      item['isAllowed'],
                      isMobile,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getAllMenuItems() {
    // Define all possible menu items
    final allMenuItems = [
      {
        'title': 'Orders',
        'icon': Icons.shopping_cart,
        'route': '/order',
        'color': Colors.blue,
        'allowedFor': ['stall'], // Only stall users can access
      },
      {
        'title': 'Issue New Card',
        'icon': Icons.credit_card,
        'route': '/issue_new_card',
        'color': Colors.blue,
        'allowedFor': ['topup'], // Only topup users can access
      },
      {
        'title': 'Top Up',
        'icon': Icons.account_balance_wallet,
        'route': '/top_up',
        'color': Colors.green,
        'allowedFor': ['topup'], // Only topup users can access
      },
      {
        'title': 'Check Balance',
        'icon': Icons.account_balance,
        'route': '/check_balance_tap_card',
        'color': Colors.orange,
        'allowedFor': ['topup'], // Only topup users can access
      },
      {
        'title': 'Refund',
        'icon': Icons.money_off,
        'route': '/refund',
        'color': Colors.red,
        'allowedFor': ['stall'], // Only stall users can access
      },
      {
        'title': 'Summary',
        'icon': Icons.analytics,
        'route': '/summary',
        'color': Colors.purple,
        'allowedFor': ['stall'], // Only stall users can access
      },
    ];

    // Add permission info to each item
    return allMenuItems.map((item) {
      // Debug print to check user type
      print('Current user type: ${currentUser?.userType}');
      print('Current user isStallUser: ${currentUser?.isStallUser}');

      final userType = currentUser?.isStallUser == true ? 'stall' : 'topup';
      final allowedFor = item['allowedFor'] as List<String>?;
      final isAllowed = allowedFor?.contains(userType) ?? false;

      print('Item: ${item['title']}, User Type: $userType, Allowed For: $allowedFor, Is Allowed: $isAllowed');

      return {
        'title': item['title'],
        'icon': item['icon'],
        'route': item['route'],
        'color': item['color'],
        'isAllowed': isAllowed,
      };
    }).toList();
  }

  Widget _buildMenuCard(String title, IconData icon, String route, Color color, bool isAllowed, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isAllowed ? () {
            Navigator.pushNamed(context, route);
          } : () {
            // Show access denied message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Access denied. You don\'t have permission to access this feature.'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Stack(
              children: [
                // Main content
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isMobile ? 12 : 16),
                      decoration: BoxDecoration(
                        color: isAllowed
                            ? color.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        size: isMobile ? 28 : 32,
                        color: isAllowed ? color : Colors.grey,
                      ),
                    ),
                    SizedBox(height: isMobile ? 8 : 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        fontWeight: FontWeight.w600,
                        color: isAllowed ? Colors.grey[800] : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                // Lock icon overlay for restricted items
                if (!isAllowed)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.lock,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
