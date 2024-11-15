import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateBudgetScreen extends StatefulWidget {
  const CreateBudgetScreen({super.key});

  @override
  _CreateBudgetScreenState createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen> {
  String? selectedAmount;
  String? selectedMonth;
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _addBudget() async {
    final amount = selectedAmount;
    final month = selectedMonth;
    
    if (amount == null || amount.isEmpty || month == null) {
      _showSnackBar("Please enter an amount and select a month.");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('budgets')
            .add({
          'amount': amount,
          'month': month,
          'createdAt': Timestamp.now(),
        });

        // Save the selected month to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('selected_month', month);

        _showSnackBar("Budget added successfully!");
        Navigator.pop(context, true);
      } catch (e) {
        _showSnackBar("Failed to add budget. Please try again.");
      }
    } else {
      _showSnackBar("User not authenticated.");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildAmountButton(String amount) {
    final isSelected = selectedAmount == amount.replaceAll('\$', '');
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedAmount = amount.replaceAll('\$', '');
          _amountController.text = selectedAmount!;
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: isSelected ? Colors.orange : Colors.grey),
      ),
      child: Text(
        amount,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: isSelected ? Colors.orange : Colors.black,
        ),
      ),
    );
  }

  Widget _buildMonthSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Month",
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: selectedMonth,
          hint: Text(
            "Choose month",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
          ),
          items: [
            'January', 'February', 'March', 'April', 'May', 'June', 'July',
            'August', 'September', 'October', 'November', 'December'
          ].map((month) {
            return DropdownMenuItem<String>(
              value: month,
              child: Text(
                month,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedMonth = value;
            });
          },
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            filled: true,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Text(
              "CREATE BUDGET",
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildAmountSelection(),
            const SizedBox(height: 20),
            _buildMonthSelection(),
            const Spacer(),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter/Select Amount",
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _amountController,
          decoration: InputDecoration(
            hintText: "Enter amount",
            hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
            border: const UnderlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              selectedAmount = value.isEmpty ? null : value;
            });
          },
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildAmountButton("\$300"),
            _buildAmountButton("\$1000"),
            _buildAmountButton("\$1200"),
            _buildAmountButton("\$2000"),
            _buildAmountButton("\$2800"),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          backgroundColor: Colors.white,
          child: const Icon(Icons.close, color: Colors.orange),
        ),
        ElevatedButton(
          onPressed: _addBudget,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Text(
              "ADD",
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
