import 'package:expenses_tracker/screens/itemscreen/item_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  _ChallengesScreenState createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  int _selectedIndex = 0;

  List<bool> _isChallengeOver = [false, false]; // assuming two challenges for this example

  // Method to change bottom navigation tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Show dialog to confirm "I GIVE UP!" action
  Future<void> _showConfirmationDialog(int index) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            'You lost the challenge',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 18 , fontWeight: FontWeight.bold ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog and update the challenge status
                setState(() {
                  _isChallengeOver[index] = true;
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'OK',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
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
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title and Tabs
              Text(
                "Challenges",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTabButton("Active", isActive: _selectedIndex == 0),
                  const SizedBox(width: 10),
                  _buildTabButton("Completed", isActive: _selectedIndex == 1),
                ],
              ),
              const SizedBox(height: 20),
              // Challenges List
              Expanded(
                child: ListView(
                  children: [
                    _buildChallengeCard("No Shopping!", "02", "12", "47", 0),
                    _buildChallengeCard("No Drinks!", "03", "02", "35", 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        child: Container(
          height: 70, // Ensure the navbar has consistent height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => _onItemTapped(0),
                child: Icon(
                  Icons.home,
                  color: _selectedIndex == 0 ? Colors.orange : Colors.grey[600],
                ),
              ),
              GestureDetector(
                onTap: () => _onItemTapped(1),
                child: Icon(
                  Icons.bar_chart,
                  color: _selectedIndex == 1 ? Colors.orange : Colors.grey[600],
                ),
              ),
              GestureDetector(
                onTap: () => _onItemTapped(2),
                child: Icon(
                  Icons.emoji_events,
                  color: _selectedIndex == 2 ? Colors.orange : Colors.grey[600],
                ),
              ),
              GestureDetector(
                onTap: () => _onItemTapped(3),
                child: Icon(
                  Icons.add,
                  color: _selectedIndex == 3 ? Colors.orange : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, {required bool isActive}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFA726) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeCard(String title, String days, String hours, String minutes, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeBox(days, "Days"),
              _buildTimeBox(hours, "Hours"),
              _buildTimeBox(minutes, "Minutes"),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              // Show the confirmation dialog
              _showConfirmationDialog(index);
            },
            child: Text(
              _isChallengeOver[index] ? "IT'S OVER" : "I GIVE UP!",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTimeBox(String time, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            time,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
