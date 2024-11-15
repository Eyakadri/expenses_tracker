import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  final String id;
  final double amount; // Changed from String to double
  final DateTime createdAt;

  Budget({required this.id, required this.amount, required this.createdAt});

  factory Budget.fromMap(DocumentSnapshot data) {
    return Budget(
      id: data.id,
      amount: (data['amount'] as num).toDouble(), // Ensure amount is converted to double
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
