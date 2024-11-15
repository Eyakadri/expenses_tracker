import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/screens/budget/create_budget_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream<QuerySnapshot> _budgetsStream;
  late Stream<QuerySnapshot> _expensesStream;
  String selectedMonth = "This Month";
  double remainingBudget = 0.0;


  @override
  void initState() {
    super.initState();
    _loadBudgets();
    _loadExpenses();
    _getSelectedMonth();
  }

  void _loadBudgets() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _budgetsStream = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('budgets')
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  void _loadExpenses() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _expensesStream = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('expenses')
          .where('month', isEqualTo: selectedMonth)
          .snapshots();

      _expensesStream.listen((snapshot) {
        double totalExpenses = 0.0;
        for (var doc in snapshot.docs) {
          totalExpenses += doc['amount'];
        }
        _calculateRemainingBudget(totalExpenses);
      });
    }
  }

  void _calculateRemainingBudget(double totalExpenses) {
    _budgetsStream.listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var latestBudget = snapshot.docs.first;
        double budgetAmount = latestBudget['amount'];
        setState(() {
          remainingBudget = budgetAmount - totalExpenses;
        });
      }
    });
  }

  Future<void> _getSelectedMonth() async {
    final prefs = await SharedPreferences.getInstance();
    final storedMonth = prefs.getString('selected_month') ?? "This Month";
    setState(() {
      selectedMonth = storedMonth;
    });
  _loadExpenses(); // Reload expenses based on the selected month

  }

  Future<void> logout() async {
    bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text("Are you sure you want to log out?", style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Confirm", style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('user_email');
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 20, 5, screenHeight),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => CreateBudgetScreen()));
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: logout,
                        child: Icon(Icons.logout_outlined, color: const Color.fromARGB(255, 233, 15, 15)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Dynamic month display
                 Text(
                   "Budget for $selectedMonth",
                 style: GoogleFonts.poppins(
                     fontSize: 20,
                      color: Colors.grey[700],
                        ),
                      ),
                  const SizedBox(height: 20),

                  StreamBuilder<QuerySnapshot>(
                    stream: _budgetsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No budgets found."));
                      }

                      var latestBudget = snapshot.data!.docs.first;
                      String amount = latestBudget['amount'];
                      Timestamp createdAt = latestBudget['createdAt'];
                      DateTime createdDate = createdAt.toDate();

                      return ListTile(
                        title: Text(
                          "\$$amount",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 230, 11, 11),
                          ),
                        ),
                        subtitle: Text(
                          DateFormat.yMMMd().format(createdDate),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: const Icon(Icons.money),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          // Remaining Budget Container
          Positioned(
            top: screenHeight / 3.7,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Remaining Budget",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "\$${remainingBudget.toStringAsFixed(2)}",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: screenHeight / 1.9,
            left: 0,
            right: 0,
            child: Container(
              height: 600,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 166, 60),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),

          // Combined Chart Section and Today & Yesterday Amounts
          Positioned(
            top: screenHeight / 2.5,
            left: size.width / 40,
            right: size.width / 40,
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight / 6, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Chart Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      return Container(
                        width: 10,
                        height: 60 - (index * 5),
                        decoration: BoxDecoration(
                          color: index == 6 ? Colors.orange : Colors.grey[400],
                          borderRadius: BorderRadius.circular(1),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "TODAY",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "\$160.30",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 60),
                      Column(
                        children: [
                          Text(
                            "YESTERDAY",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "\$130.45",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
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
