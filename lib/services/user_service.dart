import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  // Collection references
  CollectionReference get _stallUsersCollection => 
      _firestore.collection('stall_users');
  CollectionReference get _topupUsersCollection => 
      _firestore.collection('topup_users');

  // Generate unique ID for new users
  String generateUserId(UserType userType) {
    final prefix = userType == UserType.stall ? 'STL' : 'TOP';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$prefix$timestamp';
  }

  // Create new user in backend
  Future<String> createUser({
    required String email,
    required String name,
    required UserType userType,
    required String password,
  }) async {
    try {
      // Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Failed to create Firebase user');
      }

      final userId = generateUserId(userType);
      final newUser = AppUser(
        id: userId,
        email: email,
        name: name,
        userType: userType,
        createdAt: DateTime.now(),
      );

      // Store in appropriate collection based on user type
      final collection = userType == UserType.stall 
          ? _stallUsersCollection 
          : _topupUsersCollection;

      await collection.doc(userId).set(newUser.toMap());

      // Update Firebase Auth user display name
      await userCredential.user!.updateDisplayName(name);

      return userId;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in user and fetch user data
  Future<AppUser> signInUser(String email, String password) async {
    try {
      // Sign in with Firebase Auth
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user data from both collections
      final user = await getUserByEmail(email);
      if (user == null) {
        throw Exception('User not found in database');
      }

      _currentUser = user;
      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Get user by email from both collections
  Future<AppUser?> getUserByEmail(String email) async {
    try {
      // Check stall users first
      final stallQuery = await _stallUsersCollection
          .where('email', isEqualTo: email)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (stallQuery.docs.isNotEmpty) {
        final doc = stallQuery.docs.first;
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }

      // Check topup users
      final topupQuery = await _topupUsersCollection
          .where('email', isEqualTo: email)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (topupQuery.docs.isNotEmpty) {
        final doc = topupQuery.docs.first;
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }

      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // Get user by ID
  Future<AppUser?> getUserById(String userId) async {
    try {
      final userType = userId.startsWith('STL') ? UserType.stall : UserType.topup;
      final collection = userType == UserType.stall 
          ? _stallUsersCollection 
          : _topupUsersCollection;

      final doc = await collection.doc(userId).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching user by ID: $e');
      return null;
    }
  }

  // Get all users of a specific type
  Future<List<AppUser>> getUsersByType(UserType userType) async {
    try {
      final collection = userType == UserType.stall 
          ? _stallUsersCollection 
          : _topupUsersCollection;

      final query = await collection
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map((doc) => 
          AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id)
      ).toList();
    } catch (e) {
      print('Error fetching users by type: $e');
      return [];
    }
  }

  // Update user status
  Future<void> updateUserStatus(String userId, bool isActive) async {
    try {
      final userType = userId.startsWith('STL') ? UserType.stall : UserType.topup;
      final collection = userType == UserType.stall 
          ? _stallUsersCollection 
          : _topupUsersCollection;

      await collection.doc(userId).update({'isActive': isActive});
    } catch (e) {
      print('Error updating user status: $e');
      rethrow;
    }
  }

  // Check if user has access to a route
  bool hasAccessToRoute(String route) {
    if (_currentUser == null) return false;
    return _currentUser!.allowedRoutes.contains(route);
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
  }

  // Get current Firebase user
  User? get firebaseUser => _auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null && _currentUser != null;
}
