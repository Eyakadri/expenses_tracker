import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateBudgetScreen extends StatelessWidget {
  const CreateBudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Create Budget for February", style: GoogleFonts.poppins(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choose an Account", style: GoogleFonts.poppins(fontSize: 18, color: Colors.black)),
            const SizedBox(height: 10),
            _buildAccountOption("McLovin"),
            _buildAccountOption("Emilia"),
            const SizedBox(height: 30),
            Text("Enter/Select Amount", style: GoogleFonts.poppins(fontSize: 18, color: Colors.black)),
            const SizedBox(height: 10),
            _buildAmountOption("\$500"),
            _buildAmountOption("\$1000"),
            _buildAmountOption("\$2000"),
            _buildAmountOption("\$3000"),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle Create Budget
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text("ADD"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountOption(String accountName) {
    return ListTile(
      title: Text(accountName, style: GoogleFonts.poppins(fontSize: 16)),
      trailing: Radio(value: accountName, groupValue: "", onChanged: (value) {}),
    );
  }

  Widget _buildAmountOption(String amount) {
    return ListTile(
      title: Text(amount, style: GoogleFonts.poppins(fontSize: 16)),
      trailing: Radio(value: amount, groupValue: "", onChanged: (value) {}),
    );
  }
}
