
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'lib/firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await createTestUsers();
}

Future<void> createTestUsers() async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  // Create Stall User
  try {
    final stallUserCredential = await auth.createUserWithEmailAndPassword(
      email: 'stall@test.com',
      password: 'password123',
    );

    final stallUserId = 'STL${DateTime.now().millisecondsSinceEpoch}';

    await firestore.collection('stall_users').doc(stallUserId).set({
      'id': stallUserId,
      'email': 'stall@test.com',
      'name': 'Stall User',
      'userType': 'stall',
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'isActive': true,
    });

    await stallUserCredential.user!.updateDisplayName('Stall User');

    print('✅ Stall User created:');
    print('   User ID: $stallUserId');
    print('   Email: stall@test.com');
    print('   Password: password123');
    print('');

  } catch (e) {
    print('❌ Error creating stall user: $e');
  }

  // Create Top-up User
  try {
    final topupUserCredential = await auth.createUserWithEmailAndPassword(
      email: 'topup@test.com',
      password: 'password123',
    );

    final topupUserId = 'TOP${DateTime.now().millisecondsSinceEpoch}';

    await firestore.collection('topup_users').doc(topupUserId).set({
      'id': topupUserId,
      'email': 'topup@test.com',
      'name': 'Top-up User',
      'userType': 'topup',
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'isActive': true,
    });

    await topupUserCredential.user!.updateDisplayName('Top-up User');

    print('✅ Top-up User created:');
    print('   User ID: $topupUserId');
    print('   Email: topup@test.com');
    print('   Password: password123');
    print('');

  } catch (e) {
    print('❌ Error creating topup user: $e');
  }

  // Create Admin User 1
  try {
    final admin1UserCredential = await auth.createUserWithEmailAndPassword(
      email: 'admin1@test.com',
      password: 'admin123',
    );

    final admin1UserId = 'ADM${DateTime.now().millisecondsSinceEpoch}';

    await firestore.collection('admin_users').doc(admin1UserId).set({
      'id': admin1UserId,
      'email': 'admin1@test.com',
      'name': 'Admin User 1',
      'userType': 'admin',
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'isActive': true,
    });

    await admin1UserCredential.user!.updateDisplayName('Admin User 1');

    print('✅ Admin User 1 created:');
    print('   User ID: $admin1UserId');
    print('   Email: admin1@test.com');
    print('   Password: admin123');
    print('');

    // Wait a moment to ensure different timestamp for second admin
    await Future.delayed(Duration(milliseconds: 10));

  } catch (e) {
    print('❌ Error creating admin user 1: $e');
  }

  // Create Admin User 2
  try {
    final admin2UserCredential = await auth.createUserWithEmailAndPassword(
      email: 'admin2@test.com',
      password: 'admin123',
    );

    final admin2UserId = 'ADM${DateTime.now().millisecondsSinceEpoch}';

    await firestore.collection('admin_users').doc(admin2UserId).set({
      'id': admin2UserId,
      'email': 'admin2@test.com',
      'name': 'Admin User 2',
      'userType': 'admin',
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'isActive': true,
    });

    await admin2UserCredential.user!.updateDisplayName('Admin User 2');

    print('✅ Admin User 2 created:');
    print('   User ID: $admin2UserId');
    print('   Email: admin2@test.com');
    print('   Password: admin123');
    print('');

  } catch (e) {
    print('❌ Error creating admin user 2: $e');
  }

  print('🎉 Test users created successfully!');
  print('');
  print('To sign in to your app, use:');
  print('- For Stall User: Enter the STL User ID and password: password123');
  print('- For Top-up User: Enter the TOP User ID and password: password123');
  print('- For Admin User 1: Enter the ADM User ID and password: admin123');
  print('- For Admin User 2: Enter the ADM User ID and password: admin123');
}
