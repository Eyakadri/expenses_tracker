import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'itemmodel.dart';

class ItemListScreen extends StatefulWidget {
  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch items from Firestore
  Stream<List<Item>> getItems() {
    return _firestore.collection('items').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Item.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Function to update item in Firestore
  Future<void> updateItem(Item item) async {
    await _firestore.collection('items').doc(item.id).update(item.toMap());
  }

  // Function to delete item from Firestore
  Future<void> deleteItem(Item item) async {
    await _firestore.collection('items').doc(item.id).delete();
  }

  // Show dialog to edit item
  void _showEditDialog(BuildContext context, Item item) {
    TextEditingController categoryController = TextEditingController(text: item.category);
    TextEditingController amountController = TextEditingController(text: item.amount.toString());
    TextEditingController itemTypeController = TextEditingController(text: item.itemType);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: itemTypeController,
                  decoration: InputDecoration(labelText: 'Item Type'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Get updated values
                String updatedCategory = categoryController.text;
                double updatedAmount = double.tryParse(amountController.text) ?? 0;
                String updatedItemType = itemTypeController.text;

                // Create updated Item
                Item updatedItem = Item(
                  id: item.id,
                  category: updatedCategory,
                  amount: updatedAmount,
                  itemType: updatedItemType, percentageChange: 0.0, date: '',
                );

                // Update item in Firestore
                await updateItem(updatedItem);

                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Show dialog to delete item
  void _showDeleteDialog(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Delete item in Firestore
                await deleteItem(item);

                Navigator.pop(context);
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDEDED),
      appBar: AppBar(
        title: Text(
          'ITEMS LIST',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<List<Item>>(
        stream: getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items to display.'));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            itemBuilder: (context, index) {
              final item = items[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: _getCategoryColor(item.category),
                        child: Icon(
                          _getCategoryIcon(item.category),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.category,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '\$${item.amount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
              
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => _showEditDialog(context, item),
                            child: Icon(Icons.edit, color: Colors.grey, size: 16),
                          ),
                          SizedBox(width: 8),
                          InkWell(
                            onTap: () => _showDeleteDialog(context, item),
                            child: Icon(Icons.delete, color: Colors.red, size: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Function to get color based on category
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Clothes':
        return Colors.purple;
      case 'Grocery':
        return Colors.redAccent;
      case 'Coffee':
        return Colors.blueAccent;
      case 'Drinks':
        return Colors.pinkAccent;
      case 'Electric':
        return Colors.indigoAccent;
      case 'Other':
        return Colors.orangeAccent;
      default:
        return Colors.grey;
    }
  }

  // Function to get icon based on category
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Clothes':
        return Icons.checkroom;
      case 'Grocery':
        return Icons.shopping_cart;
      case 'Coffee':
        return Icons.local_cafe;
      case 'Drinks':
        return Icons.local_bar;
      case 'Electric':
        return Icons.electrical_services;
      default:
        return Icons.category;
    }
  }
}
