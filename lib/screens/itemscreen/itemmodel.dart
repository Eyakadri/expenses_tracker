class Item {
  final String? id; // Optional Firestore document ID
  final String category;
  final double amount;
  final double percentageChange; // New field for percentage change
  final String itemType;
  final String date;
  

  Item({
    this.id, // Optional parameter
    required this.category,
    required this.amount,
    required this.percentageChange, // Required in constructor
    required this.itemType,
    required this.date,
  });

  // Convert Item instance to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'amount': amount,
      'percentageChange': percentageChange, // Include percentageChange in map
      'itemType': itemType,
      'date': date,
    };
  }

  // Factory constructor to create an Item from Firestore data
  factory Item.fromMap(Map<String, dynamic> map, String id) {
    return Item(
      id: id, // Firestore ID passed in here
      category: map['category'] ?? 'Unknown', // Default category if missing
      amount: (map['amount'] is num) ? (map['amount'] as num).toDouble() : 0.0, // Safely handle amount
      percentageChange: (map['percentageChange'] is num) 
          ? (map['percentageChange'] as num).toDouble() 
          : 0.0, // Default to 0.0 if missing
      itemType: map['itemType'] ?? 'General', date: '', // Default itemType if missing
    );
  }

  // Optional: Add a method to format the amount
  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';
}
