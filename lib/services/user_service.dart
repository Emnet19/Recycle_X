import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize new user with 500 EcoCoins
  static Future<void> initializeNewUser(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final doc = await userDoc.get();

    // Only initialize if user doesn't exist in Firestore
    if (!doc.exists) {
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName ?? '',
        'phone': '',
        'address': '',
        'city': 'Addis Ababa',
        'ecoCoins': 500,          // New user gets 500 coins
        'totalEarned': 500,       // Total earned = 500
        'totalRedeemed': 0,       // Never spent
        'totalRecycled': 0,
        'totalPickups': 0,
        'totalEmergencyPickups': 0,
        'userLevel': 'Eco Beginner',
        'isNewUser': true,
        'profileComplete': false,
        'registrationDate': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Add welcome transaction
      await _firestore.collection('transactions').add({
        'userId': user.uid,
        'type': 'bonus',
        'category': 'welcome',
        'description': 'Welcome Bonus!',
        'amount': 500,
        'date': FieldValue.serverTimestamp(),
        'isPositive': true,
        'metadata': {
          'reason': 'new_user_registration',
          'message': 'Welcome to RecycleX! Complete your profile.'
        }
      });
    }
  }

  // Check if user needs to complete profile
  static Future<bool> needsProfileCompletion(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    
    if (!doc.exists) return true;
    
    final data = doc.data()!;
    final isProfileComplete = data['profileComplete'] == true;
    final hasName = (data['name'] as String?)?.isNotEmpty ?? false;
    final hasPhone = (data['phone'] as String?)?.isNotEmpty ?? false;
    
    return !isProfileComplete || !hasName || !hasPhone;
  }

  // Mark profile as complete
  static Future<void> markProfileComplete({
    required String userId,
    required String name,
    required String phone,
    required String address,
    required String city,
  }) async {
    await _firestore.collection('users').doc(userId).update({
      'name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'profileComplete': true,
      'profileCompletedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUserData(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data();
  }
}