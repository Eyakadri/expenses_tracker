import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/screens/itemscreen/item_list_screen.dart';
import 'package:expenses_tracker/screens/itemscreen/itemmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  String? selectedCategory;
  double? selectedAmount;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _itemTypeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  // List to store items
  final List<Item> _items = [];

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void selectAmount(double amount) {
    setState(() {
      selectedAmount = amount;
      _amountController.text = amount.toString();
    });
  }

  void _addItem() async {
    if (selectedCategory == null || selectedAmount == null || _itemTypeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select a category, amount, and enter item type."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create an Item object with the selected data
    final newItem = Item(
      category: selectedCategory!,
      amount: selectedAmount!,
      itemType: _itemTypeController.text,
      percentageChange: 0.0, date: '',
    );

    // Add the new item to Firestore
    try {
      final itemRef = FirebaseFirestore.instance.collection('items').doc();
      await itemRef.set(newItem.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Item added successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        selectedCategory = null;
        selectedAmount = null;
        _itemTypeController.clear();
        _amountController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error adding item: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to navigate to ItemListScreen
  void _viewItemList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemListScreen(),
      ),
    );
  }

  // Method for the custom date picker
  void _selectDate() async {
    DateTime currentDate = DateTime.now();
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(currentDate.year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange, // Button text color
              ),
            ),
            dialogBackgroundColor: Colors.white, // Background color
          ),
          child: child!,
        );
      },
    );

    // Update the text field if a new date is selected
    if (newDate != null) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Center(
              child: Text(
                "ADD ITEM MANUALLY",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            _buildCategorySelection(),
            const SizedBox(height: 20),
            _buildAmountInput(),
            const SizedBox(height: 20),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Category",
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCategoryOption("CLOTHES", Icons.checkroom, Colors.purple[200]!),
            _buildCategoryOption("GROCERY", Icons.shopping_cart, Colors.orange[200]!),
            _buildCategoryOption("DRINKS", Icons.local_drink, Colors.blue[200]!),
            _buildCategoryOption("COFFEE", Icons.coffee, Colors.brown[200]!),
            _buildCategoryOption("HEALTH", Icons.local_hospital, const Color.fromARGB(255, 189, 130, 130)!),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryOption(String label, IconData icon, Color color) {
    bool isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () => selectCategory(label),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: isSelected ? color : color.withOpacity(0.5),
            radius: 30,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How Much?",
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter amount",
            hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
          ),
          onChanged: (value) {
            setState(() {
              selectedAmount = double.tryParse(value);
            });
          },
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildAmountButton(50),
            _buildAmountButton(70),
            _buildAmountButton(100),
            _buildAmountButton(220),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "Type of Item",
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
        ),
        TextField(
          controller: _itemTypeController,
          decoration: InputDecoration(
            hintText: "Name (Ex: Shirt)",
            hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: dateController,
          readOnly: true,
          onTap: _selectDate,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(
              FontAwesomeIcons.clock,
              size: 16,
              color: Colors.grey,
            ),
            hintText: 'Date',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountButton(double amount) {
    bool isSelected = selectedAmount == amount;
    return OutlinedButton(
      onPressed: () => selectAmount(amount),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.orange[200] : Colors.transparent,
        side: BorderSide(color: isSelected ? Colors.orange : Colors.grey[400]!),
      ),
      child: Text(
        "\$$amount",
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.black : Colors.black,
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: _addItem,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: Text(
            "Add Item",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: _viewItemList,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[400],
          ),
          child: Text(
            "View Items",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
