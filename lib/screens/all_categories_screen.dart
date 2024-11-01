import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("All Categories", style: GoogleFonts.poppins(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildCategoryTile("Clothes", "\$582.30", Colors.purple),
            _buildCategoryTile("Grocery", "\$320.00", Colors.teal),
            _buildCategoryTile("Coffee", "\$180.00", Colors.brown),
            _buildCategoryTile("Drinks", "\$210.50", Colors.red),
            _buildCategoryTile("Electric", "\$75.80", Colors.blue),
            _buildCategoryTile("Other", "\$120.50", Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(String category, String amount, Color color) {
    return ListTile(
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.category, color: color),
      ),
      title: Text(category, style: GoogleFonts.poppins(fontSize: 16)),
      trailing: Text(amount, style: GoogleFonts.poppins(fontSize: 16, color: Colors.black)),
    );
  }
}
