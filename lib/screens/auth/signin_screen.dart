import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../../services/user_service.dart';
import '../../models/user.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String _selectedUserType = 'stall'; // Default selection

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Get user input and clean it
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();
        final userType = _selectedUserType;

        print('Attempting to sign in with:');
        print('Email: "$email"');
        print('Password: "$password"');
        print('User Type: $userType');

        // Search for specific user by email to reduce query time
        final QuerySnapshot querySnapshot = await _firestore
            .collection(userType)
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        bool userFound = false;
        AppUser? authenticatedUser;

        // Check if user exists and password matches
        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          final userData = doc.data() as Map<String, dynamic>;
          final docPassword = (userData['password']?.toString().trim()) ?? '';

          if (docPassword == password) {
            userFound = true;
            // Store user information in UserService for later use
            // Ensure user type is set correctly based on collection
            userData['userType'] = userType; // Set the userType based on which collection we found the user in
            authenticatedUser = AppUser.fromMap(userData, doc.id);
            UserService().setCurrentUser(authenticatedUser);
          }
        }

        if (userFound) {
          if (mounted) {
            // Navigate to dashboard immediately
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        } else {
          print('User not found or credentials don\'t match');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Invalid email, password, or user type. Please try again.',
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (e) {
        print('Firestore error: $e');
        print('Error type: ${e.runtimeType}');
        if (mounted) {
          String errorMessage;

          if (e.toString().contains('permission-denied')) {
            errorMessage =
            'Access denied. Please update Firestore security rules.';
          } else if (e.toString().contains('network') ||
              e.toString().contains('connection')) {
            errorMessage =
            'Network error. Please check your internet connection.';
          } else {
            errorMessage = 'An unexpected error occurred. Please try again.';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    children: [
                      // Header Section
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 40,
                          horizontal: 24,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Welcome back! Please sign in to your account',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      // Form Section
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: isMobile ? double.infinity : 400,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, -10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20),

                              // Email Field
                              _buildInputField(
                                controller: _emailController,
                                label: 'User ID',
                                hint: 'Enter your user ID',
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter user ID';
                                  }
                                  if (!RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                  ).hasMatch(value.trim())) {
                                    return 'Please enter a valid user ID';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 24),

                              // Password Field
                              _buildInputField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: 'Enter your password',
                                icon: Icons.lock,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Color(0xFF1976D2),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 24),

                              // User Type Selection
                              _buildUserTypeSelection(),
                              SizedBox(height: 40),

                              // Sign In Button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _signIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF1976D2),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isLoading
                                      ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                      : Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1976D2),
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedUserType = 'stall';
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedUserType == 'stall'
                        ? Color(0xFF1976D2).withOpacity(0.1)
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedUserType == 'stall'
                          ? Color(0xFF1976D2)
                          : Colors.grey[300]!,
                      width: _selectedUserType == 'stall' ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _selectedUserType == 'stall'
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: _selectedUserType == 'stall'
                            ? Color(0xFF1976D2)
                            : Colors.grey[600],
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.store,
                        color: _selectedUserType == 'stall'
                            ? Color(0xFF1976D2)
                            : Colors.grey[600],
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Stall',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _selectedUserType == 'stall'
                              ? Color(0xFF1976D2)
                              : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedUserType = 'topup';
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedUserType == 'topup'
                        ? Color(0xFF1976D2).withOpacity(0.1)
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedUserType == 'topup'
                          ? Color(0xFF1976D2)
                          : Colors.grey[300]!,
                      width: _selectedUserType == 'topup' ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _selectedUserType == 'topup'
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: _selectedUserType == 'topup'
                            ? Color(0xFF1976D2)
                            : Colors.grey[600],
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.account_balance_wallet,
                        color: _selectedUserType == 'topup'
                            ? Color(0xFF1976D2)
                            : Colors.grey[600],
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Top-up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _selectedUserType == 'topup'
                              ? Color(0xFF1976D2)
                              : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required FormFieldValidator<String> validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1976D2),
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: Icon(icon, color: Color(0xFF1976D2)),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF1976D2), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          validator: validator,
        ),
      ],
    );
  }
}