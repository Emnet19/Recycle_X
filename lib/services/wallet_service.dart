import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart';

class WalletService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's eco coins balance
  static Future<int> getEcoCoinsBalance() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return (doc.data()?['ecoCoins'] ?? 0).toInt();
    } catch (e) {
      print('Error getting eco coins: $e');
      return 0;
    }
  }

  // Add eco coins to user account
  static Future<void> addEcoCoins({
    required int amount,
    required String category,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final batch = _firestore.batch();
    final userRef = _firestore.collection('users').doc(user.uid);
    final transactionRef = _firestore.collection('transactions').doc();

    // Create transaction
    final transaction = EcoTransaction(
      id: transactionRef.id,
      userId: user.uid,
      type: 'earn',
      category: category,
      description: description,
      amount: amount,
      date: DateTime.now(),
      isPositive: true,
      metadata: metadata,
    );

    // Update user balance
    batch.update(userRef, {
      'ecoCoins': FieldValue.increment(amount),
      'totalEarned': FieldValue.increment(amount),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Add transaction
    batch.set(transactionRef, transaction.toFirestore());

    await batch.commit();
  }

  // Deduct eco coins (for redemptions, emergency pickups, etc.)
  static Future<void> deductEcoCoins({
    required int amount,
    required String category,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    // Check balance first
    final currentBalance = await getEcoCoinsBalance();
    if (currentBalance < amount) {
      throw Exception('Insufficient eco coins');
    }

    final batch = _firestore.batch();
    final userRef = _firestore.collection('users').doc(user.uid);
    final transactionRef = _firestore.collection('transactions').doc();

    // Create transaction
    final transaction = EcoTransaction(
      id: transactionRef.id,
      userId: user.uid,
      type: 'redeem',
      category: category,
      description: description,
      amount: amount,
      date: DateTime.now(),
      isPositive: false,
      metadata: metadata,
    );

    // Update user balance
    batch.update(userRef, {
      'ecoCoins': FieldValue.increment(-amount),
      'totalRedeemed': FieldValue.increment(amount),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Add transaction
    batch.set(transactionRef, transaction.toFirestore());

    await batch.commit();
  }

  // Get user transactions
  static Stream<List<EcoTransaction>> getTransactions() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EcoTransaction.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Get available rewards
  static List<Reward> getAvailableRewards(int userBalance) {
    return [
      Reward(
        id: '1',
        name: 'Eco-straw Set',
        description: 'Set of 5 reusable metal straws',
        cost: 1250,
        imageUrl: 'assets/straws.png',
      ),
      Reward(
        id: '2',
        name: 'Cotton Tote Bag',
        description: 'Reusable shopping bag',
        cost: 800,
        imageUrl: 'assets/tote_bag.png',
      ),
      Reward(
        id: '3',
        name: 'Plant a Tree',
        description: 'We\'ll plant a tree in your name',
        cost: 500,
        imageUrl: 'assets/tree.png',
      ),
      Reward(
        id: '4',
        name: 'Coffee Mug',
        description: 'Reusable ceramic coffee mug',
        cost: 1500,
        imageUrl: 'assets/mug.png',
      ),
      Reward(
        id: '5',
        name: 'Water Bottle',
        description: 'Stainless steel water bottle',
        cost: 2000,
        imageUrl: 'assets/water_bottle.png',
      ),
    ];
  }
}

class Reward {
  final String id;
  final String name;
  final String description;
  final int cost;
  final String imageUrl;

  Reward({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.imageUrl,
  });
}