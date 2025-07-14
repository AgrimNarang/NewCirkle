import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  // Sign in with email and password
  Future<AppUser?> signIn(String email, String password) async {
    try {
      // Authenticate with Firebase
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Try to find user in stall_users collection first
        final stallDoc = await _firestore
            .collection('stall_users')
            .doc(userCredential.user!.uid)
            .get();

        if (stallDoc.exists) {
          _currentUser = AppUser.fromMap(stallDoc.data()!, stallDoc.id);
          return _currentUser;
        }

        // If not found in stall_users, try topup_users collection
        final topupDoc = await _firestore
            .collection('topup_users')
            .doc(userCredential.user!.uid)
            .get();

        if (topupDoc.exists) {
          _currentUser = AppUser.fromMap(topupDoc.data()!, topupDoc.id);
          return _currentUser;
        }

        // If user document doesn't exist in either collection
        throw Exception('User data not found. Please contact administrator.');
      }

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found with this email address.');
        case 'wrong-password':
          throw Exception('Invalid password.');
        case 'invalid-email':
          throw Exception('Invalid email address format.');
        case 'user-disabled':
          throw Exception('This account has been disabled.');
        case 'too-many-requests':
          throw Exception('Too many login attempts. Please try again later.');
        default:
          throw Exception('Sign in failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser = null;
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null && _currentUser != null;

  // Get current Firebase user
  User? get firebaseUser => _auth.currentUser;

  // Initialize user session (call this on app start)
  Future<void> initializeUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      // Try to load user data from Firestore
      try {
        // Check stall_users first
        final stallDoc = await _firestore
            .collection('stall_users')
            .doc(firebaseUser.uid)
            .get();

        if (stallDoc.exists) {
          _currentUser = AppUser.fromMap(stallDoc.data()!, stallDoc.id);
          return;
        }

        // Check topup_users
        final topupDoc = await _firestore
            .collection('topup_users')
            .doc(firebaseUser.uid)
            .get();

        if (topupDoc.exists) {
          _currentUser = AppUser.fromMap(topupDoc.data()!, topupDoc.id);
          return;
        }

        // If no user document found, sign out
        await signOut();
      } catch (e) {
        // If error loading user data, sign out
        await signOut();
      }
    }
  }

  // Create a new user account
  Future<AppUser?> createUser({
    required String email,
    required String password,
    required String name,
    required UserType userType,
  }) async {
    try {
      // Create Firebase user
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Generate user ID based on type
        final String userId = _generateUserId(userType);

        // Create user document
        final userData = {
          'email': email,
          'name': name,
          'userType': userType.toString().split('.').last,
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        // Determine collection based on user type
        final String collection = userType == UserType.stall ? 'stall_users' : 'topup_users';

        // Save to appropriate collection
        await _firestore.collection(collection).doc(userCredential.user!.uid).set(userData);

        // Create and return AppUser object
        final newUser = AppUser(
          id: userCredential.user!.uid,
          email: email,
          name: name,
          userType: userType,
          createdAt: DateTime.now(),
          isActive: true,
        );

        _currentUser = newUser;
        return newUser;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw Exception('The password is too weak.');
        case 'email-already-in-use':
          throw Exception('An account already exists with this email.');
        case 'invalid-email':
          throw Exception('Invalid email address format.');
        default:
          throw Exception('Account creation failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Generate user ID based on type
  String _generateUserId(UserType userType) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final prefix = userType == UserType.stall ? 'STL' : 'TOP';
    return '$prefix$timestamp';
  }

  // Get all users by type (for admin purposes)
  Future<List<AppUser>> getUsersByType(UserType userType) async {
    try {
      final String collection = userType == UserType.stall ? 'stall_users' : 'topup_users';
      final QuerySnapshot snapshot = await _firestore.collection(collection).get();

      return snapshot.docs.map((doc) =>
          AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id)
      ).toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  // Update user status
  Future<void> updateUserStatus(String userId, bool isActive, UserType userType) async {
    try {
      final String collection = userType == UserType.stall ? 'stall_users' : 'topup_users';
      await _firestore.collection(collection).doc(userId).update({
        'isActive': isActive,
      });
    } catch (e) {
      throw Exception('Failed to update user status: $e');
    }
  }

  // Set current user (for admin operations)
  void setCurrentUser(AppUser? user) {
    _currentUser = user;
  }

  void clearCurrentUser() {
    _currentUser = null;
  }
}