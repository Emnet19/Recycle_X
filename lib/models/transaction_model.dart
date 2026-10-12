import 'package:cloud_firestore/cloud_firestore.dart'; // ADD THIS IMPORT


class EcoTransaction {
  final String id;
  final String userId;
  final String type; // 'earn', 'redeem', 'transfer', 'bonus'
  final String category; // 'pickup', 'referral', 'bonus', 'redemption'
  final String description;
  final int amount;
  final DateTime date;
  final bool isPositive; // true for income, false for expense
  final Map<String, dynamic>? metadata; // additional data

  EcoTransaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    required this.isPositive,
    this.metadata,
  });

  factory EcoTransaction.fromFirestore(Map<String, dynamic> data, String docId) {
    return EcoTransaction(
      id: docId,
      userId: data['userId'] ?? '',
      type: data['type'] ?? 'earn',
      category: data['category'] ?? 'other',
      description: data['description'] ?? '',
      amount: (data['amount'] ?? 0).toInt(),
      date: (data['date'] as Timestamp).toDate(),
      isPositive: data['isPositive'] ?? true,
      metadata: data['metadata'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type,
      'category': category,
      'description': description,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'isPositive': isPositive,
      if (metadata != null) 'metadata': metadata,
    };
  }
}