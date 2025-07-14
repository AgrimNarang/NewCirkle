# Dual User Authentication System Implementation

## Overview
This implementation provides a dual login system with two distinct user types:
1. **Stall Users** - Have access to all features except order management
2. **Top-up Users** - Have limited access to issue new cards, top-up, and check balance

## Backend Structure

### Collections
- `stall_users` - Contains all stall-based users
- `topup_users` - Contains all top-up based users

### User ID Generation
- **Stall Users**: `STL{timestamp}` (e.g., STL1705234567890)
- **Top-up Users**: `TOP{timestamp}` (e.g., TOP1705234567890)

## User Permissions

### Stall Users
- ✅ Issue New Card
- ✅ Top Up
- ✅ Check Balance
- ❌ Orders (Excluded as per requirement)
- ✅ Refund
- ✅ Summary
- ✅ Admin Panel (for demo)

### Top-up Users
- ✅ Issue New Card
- ✅ Top Up
- ✅ Check Balance
- ❌ Orders
- ❌ Refund
- ❌ Summary
- ❌ Admin Panel

## Key Components

### 1. User Model (`lib/models/user.dart`)
```dart
enum UserType { stall, topup }

class AppUser {
  final String id;
  final String email;
  final String name;
  final UserType userType;
  final DateTime createdAt;
  final bool isActive;
  
  // Helper methods
  bool get isStallUser => userType == UserType.stall;
  bool get isTopupUser => userType == UserType.topup;
  List<String> get allowedRoutes; // Returns permitted routes
}
```

### 2. User Service (`lib/services/user_service.dart`)
- Manages user authentication and authorization
- Handles user creation with auto-generated IDs
- Provides methods to check user permissions
- Manages separate collections for different user types

### 3. Route Guard (`lib/widgets/route_guard.dart`)
- Protects routes based on user permissions
- Shows access denied screen for unauthorized routes
- Redirects unauthenticated users to login

### 4. Enhanced Dashboard (`lib/screens/dashboard/dashboard_screen.dart`)
- Displays different options based on user type
- Shows user type and name in header
- Includes sign-out functionality

### 5. Admin Panel (`lib/screens/admin/admin_user_management_screen.dart`)
- Lists all users by type
- Shows user status (active/inactive)
- Allows activation/deactivation of users
- Displays user permissions and creation dates

## Usage

### Creating Users
1. Navigate to Sign Up screen
2. Fill in user details
3. Select user type (Top-up User or Stall User)
4. Submit to create account with auto-generated ID

### Sign In
1. Enter email and password
2. System automatically detects user type
3. Redirects to dashboard with appropriate permissions

### Admin Management
- Access via `/admin` route (currently restricted to stall users)
- View all users categorized by type
- Manage user status (activate/deactivate)

## Database Schema

### Stall Users Collection
```
stall_users/
  ├── STL1705234567890/
  │   ├── email: "user@example.com"
  │   ├── name: "John Doe"
  │   ├── userType: "stall"
  │   ├── createdAt: Timestamp
  │   └── isActive: true
```

### Top-up Users Collection
```
topup_users/
  ├── TOP1705234567890/
  │   ├── email: "user@example.com"
  │   ├── name: "Jane Smith"
  │   ├── userType: "topup"
  │   ├── createdAt: Timestamp
  │   └── isActive: true
```

## Security Features
- Route-level protection
- User type-based authorization
- Firebase Authentication integration
- Automatic sign-out on unauthorized access
- Session management

## Testing
1. Create both types of users through sign-up
2. Test login with each user type
3. Verify dashboard shows appropriate options
4. Test route protection by trying to access restricted features
5. Use admin panel to manage users

## Future Enhancements
- Role-based permissions (admin, manager, employee)
- User activity logging
- Bulk user management
- Advanced user filtering and search
- User profile management
