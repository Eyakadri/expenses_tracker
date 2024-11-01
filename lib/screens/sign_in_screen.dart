import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8), // Background color matching the UI kit
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon
              const Icon(
                Icons.monetization_on,
                size: 80,
                color: Color(0xFFFFA726), // Orange color matching UI kit
              ),
              const SizedBox(height: 30),
              
              // Title
              Text(
                "Sign In",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              
              // Subtitle
              Text(
                "If you already registered",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              
              // Text Fields
              _buildTextField("Username/Email", emailController),
              const SizedBox(height: 15),
              _buildTextField("Password", passwordController, obscureText: true),
              const SizedBox(height: 20),
              
              // Sign In Button
              ElevatedButton(
                onPressed: () async {
                  try {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    Navigator.pushReplacementNamed(context, '/home');
                  } catch (e) {
                    if (kDebugMode) {
                      print('Sign in failed: $e');
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sign in failed: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA726), // Orange button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  "SIGN IN",
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              
              // Social Icons
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.facebook, color: Color(0xFFFFA726), size: 30),
                  SizedBox(width: 15),
                  Icon(Icons.mail, color: Color(0xFFFFA726), size: 30),
                ],
              ),
              
              // Register Redirect
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(
                  "Don't have an account? Register",
                  style: GoogleFonts.poppins(color: const Color(0xFFFFA726)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom TextField Builder
  Widget _buildTextField(String hint, TextEditingController controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.white, // White background for text fields
      ),
    );
  }
}
