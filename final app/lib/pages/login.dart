import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/components/my_textfield.dart';
//import 'package:app/components/sbuttone.dart';
import 'package:app/user_auth/firebase_auth_ser.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void loginUser(BuildContext context) {
    // Implement your login logic here

    // Navigate back to the sign-in page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(height: 30),
              MyTextField(
                controller: usernameController,
                hinttext: 'Username',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: emailController,
                hinttext: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hinttext: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // i wanna add a button here
              GestureDetector(
                onTap: _signup,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Signin",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                "Already have an Account? ",
              ),
              GestureDetector(
                onTap: () {
                  loginUser(context); // Navigate back to the sign-in page
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.blue, // Change the text color to blue
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signup() async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);
      if (user != null) {
        print("User is successfully created");
        Navigator.pushNamed(context, "/home");
      } else {
        print("Some error happened");
      }
    } catch (e) {
      if (e is FirebaseException) {
        print("Firebase Auth Exception: ${e.message}");
        // Handle specific Firebase Auth exceptions here
      } else {
        print("Unexpected error: $e");
      }
    }
  }
}
