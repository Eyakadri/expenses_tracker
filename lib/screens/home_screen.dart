import 'package:expenses_tracker/screens/itemscreen/add_item_screen.dart';
import 'package:expenses_tracker/screens/challenges_screen.dart';
import 'package:expenses_tracker/screens/stats/stat_screen.dart'; // Ensure this import is correct and the file exists
import 'package:expenses_tracker/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected index
static final List<Widget> _screens =<Widget>[
  Home(),
  StatScreen(),
  ChallengesScreen(),
  AddItemScreen()

];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: Stack(
        children: [
          // Main Budget Container
          _screens[_selectedIndex],

          // Bottom Navigation Bar with padding and rounded corners
          Positioned(
            bottom: screenHeight / 35,
            left: size.width / 40,
            right: size.width / 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
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
        ],
      ),
    );
  }
}

class StatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Stat Screen'),
      ),
    );
  }
}
