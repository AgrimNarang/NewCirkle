
import 'package:flutter/material.dart';
import '../cards/issue_new_card_screen.dart';
import '../cards/top_up_screen.dart';
import '../../services/user_service.dart';
import '../../models/user.dart';

class DashboardScreen extends StatelessWidget {
  final UserService _userService = UserService();

  // Define all possible dashboard items
  final List<_DashboardItem> _allItems = [
    _DashboardItem(
      icon: Icons.credit_card,
      label: "Issue New Card",
      route: '/issue_new_card',
      userTypes: [UserType.stall, UserType.topup],
    ),
    _DashboardItem(
      icon: Icons.account_balance_wallet, 
      label: "Top Up", 
      route: '/topup',
      userTypes: [UserType.stall, UserType.topup],
    ),
    _DashboardItem(
      icon: Icons.account_balance,
      label: "Check Balance",
      route: '/check_balance_tap_card',
      userTypes: [UserType.stall, UserType.topup],
    ),
    _DashboardItem(
      icon: Icons.shopping_cart, 
      label: "Order", 
      route: '/order',
      userTypes: [UserType.stall], // Only stall users can access orders
    ),
    _DashboardItem(
      icon: Icons.money_off, 
      label: "Refund", 
      route: '/refund',
      userTypes: [UserType.stall],
    ),
    _DashboardItem(
      icon: Icons.analytics,
      label: "Summary",
      route: '/summary',
      userTypes: [UserType.stall],
    ),
    _DashboardItem(
      icon: Icons.admin_panel_settings,
      label: "Admin Panel",
      route: '/admin',
      userTypes: [UserType.stall], // For demo purposes, only stall users can access admin
    ),
  ];

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1200;

    // Get current user and filter items based on user type
    final currentUser = _userService.currentUser;
    final items = currentUser != null 
        ? _allItems.where((item) => item.userTypes.contains(currentUser.userType)).toList()
        : _allItems;

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Header with user info
            Container(
              height: isMobile ? 140 : (isTablet ? 160 : 180),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 32,
                  vertical: isMobile ? 16 : 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cirkle",
                              style: TextStyle(
                                fontSize: isMobile ? 32 : (isTablet ? 36 : 40),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "An ecosystem for events",
                              style: TextStyle(
                                fontSize: isMobile ? 14 : (isTablet ? 16 : 18),
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        // Sign out button
                        IconButton(
                          onPressed: () => _signOut(context),
                          icon: Icon(Icons.logout, color: Colors.white),
                          tooltip: 'Sign Out',
                        ),
                      ],
                    ),
                    if (currentUser != null) ...[
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${currentUser.isStallUser ? 'Stall User' : 'Top-up User'} • ${currentUser.name}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Improved Grid Section
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(isMobile ? 16 : 24),
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dashboard",
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Choose an option to get started",
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 2 : (isTablet ? 3 : 4),
                          mainAxisSpacing: isMobile ? 16 : 20,
                          crossAxisSpacing: isMobile ? 16 : 20,
                          childAspectRatio: isMobile ? 1.0 : 1.1,
                        ),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _DashboardButton(
                            icon: item.icon,
                            label: item.label,
                            onTap: () {
                              Navigator.pushNamed(context, item.route);
                            },
                            isMobile: isMobile,
                            isTablet: isTablet,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _userService.signOut();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Enhanced Button Widget with better responsiveness
class _DashboardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isMobile;
  final bool isTablet;

  const _DashboardButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isMobile = false,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFF1976D2).withOpacity(0.1), width: 1),
            gradient: LinearGradient(
              colors: [
                Color(0xFF1976D2).withOpacity(0.05),
                Color(0xFF42A5F5).withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                decoration: BoxDecoration(
                  color: Color(0xFF1976D2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: isMobile ? 32 : (isTablet ? 36 : 40),
                  color: Color(0xFF1976D2),
                ),
              ),
              SizedBox(height: isMobile ? 8 : 12),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isMobile ? 12 : (isTablet ? 14 : 16),
                    color: Color(0xFF1976D2),
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dashboard menu item data model
class _DashboardItem {
  final IconData icon;
  final String label;
  final String route;
  final List<UserType> userTypes;
  
  _DashboardItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.userTypes,
  });
}
