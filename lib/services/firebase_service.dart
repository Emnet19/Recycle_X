// // services/firebase_service.dart
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirebaseService {
//   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Save emergency pickup to Firestore
//   static Future<void> saveEmergencyPickup({
//     required String wasteType,
//     required String reason,
//     required String address,
//     required double latitude,
//     required double longitude,
//     required int ecoCoins,
//     required String phone,
//     required String userName,
//     required String userEmail,
//   }) async {
//     try {
//       // Generate a unique ID for the pickup
//       final pickupId = DateTime.now().millisecondsSinceEpoch.toString();
//       final now = DateTime.now();

//       // Create pickup data
//       final pickupData = {
//         'id': pickupId,
//         'wasteType': wasteType,
//         'reason': reason,
//         'address': address,
//         'latitude': latitude,
//         'longitude': longitude,
//         'phone': phone,
//         'userName': userName,
//         'userEmail': userEmail,
//         'ecoCoins': ecoCoins,
//         'status': 'pending', // pending, accepted, completed, cancelled
//         'createdAt': now.toIso8601String(),
//         'scheduledTime': now.add(Duration(minutes: 30)).toIso8601String(),
//         'isUrgent': true,
//       };

//       // Save to Firestore
//       await _firestore
//           .collection('emergency_pickups')
//           .doc(pickupId)
//           .set(pickupData);

//       print('✅ Emergency pickup saved to Firestore: $pickupId');
      
//       // Also save to a subcollection for user-specific pickups
//       final userEmailClean = userEmail.replaceAll('.', '_');
//       await _firestore
//           .collection('users')
//           .doc(userEmailClean)
//           .collection('my_pickups')
//           .doc(pickupId)
//           .set(pickupData);
          
//     } catch (e) {
//       print(' Error saving to Firestore: $e');
//       rethrow;
//     }
//   }

//   // Get all emergency pickups
//   static Stream<List<Map<String, dynamic>>> getAllEmergencyPickups() {
//     return _firestore
//         .collection('emergency_pickups')
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return {
//           ...doc.data(),
//           'id': doc.id,
//         };
//       }).toList();
//     });
//   }

//   // Get user's emergency pickups
//   static Stream<List<Map<String, dynamic>>> getUserEmergencyPickups(String userEmail) {
//     final userEmailClean = userEmail.replaceAll('.', '_');
//     return _firestore
//         .collection('users')
//         .doc(userEmailClean)
//         .collection('my_pickups')
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return {
//           ...doc.data(),
//           'id': doc.id,
//         };
//       }).toList();
//     });
//   }

//   // Update pickup status
//   static Future<void> updatePickupStatus(String pickupId, String status) async {
//     try {
//       await _firestore
//           .collection('emergency_pickups')
//           .doc(pickupId)
//           .update({
//             'status': status,
//             'updatedAt': DateTime.now().toIso8601String(),
//           });
//     } catch (e) {
//       print('Error updating status: $e');
//       rethrow;
//     }
//   }
// }








// services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveEmergencyPickup({
    required String userId, // ✅ UID
    required String wasteType,
    required String reason,
    required String address,
    required double latitude,
    required double longitude,
    required int ecoCoins,
    required String phone,
    required String userName,
    required String userEmail,
  }) async {
    try {
      final pickupId = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();

      final pickupData = {
        'id': pickupId,
        'userId': userId, // ✅ store uid
        'wasteType': wasteType,
        'reason': reason,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'phone': phone,
        'userName': userName,
        'userEmail': userEmail,
        'ecoCoins': ecoCoins,
        'status': 'pending',
        'createdAt': now,
        'scheduledTime': now.add(const Duration(minutes: 30)),
        'isUrgent': true,
      };

      // Main collection
      await _firestore
          .collection('emergency_pickups')
          .doc(pickupId)
          .set(pickupData);

      // User subcollection (UID based ✅)
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('my_pickups')
          .doc(pickupId)
          .set(pickupData);

      print('Emergency pickup saved');
    } catch (e) {
      print(' Firestore error: $e');
      rethrow;
    }
  }
}
