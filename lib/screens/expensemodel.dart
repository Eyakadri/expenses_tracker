import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final double amount;
  final DateTime createdAt;

  Expense({required this.id, required this.amount, required this.createdAt});

  factory Expense.fromMap(DocumentSnapshot data) {
    return Expense(
      id: data.id,
      amount: (data['amount'] as num).toDouble(),  // Ensures compatibility with Firestore's number format
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
