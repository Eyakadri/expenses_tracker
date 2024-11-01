import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Add Item to Expenses", style: GoogleFonts.poppins(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildOptionCard(Icons.camera_alt, "Scan Barcode"),
            const SizedBox(height: 20),
            _buildOptionCard(Icons.edit, "Add Manually"),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.orange),
          const SizedBox(width: 20),
          Text(label, style: GoogleFonts.poppins(fontSize: 18, color: Colors.black)),
        ],
      ),
    );
  }
}
