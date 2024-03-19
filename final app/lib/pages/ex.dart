import 'package:app/global/toast.dart';
// ignore: unused_import
import 'package:app/home.dart';
import 'package:app/pages/ex1.dart';
import 'package:app/pages/form_container_widget.dart';
import 'package:app/user_auth/firebase_auth_ser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class page extends StatefulWidget {
  const page({Key? key}) : super(key: key);

  @override
  State<page> createState() => _PageState();
}

class _PageState extends State<page> {
  bool _isSigning = false;

  final FirebaseAuthService _auth = FirebaseAuthService();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 22, 3, 2)),
            ),
            const SizedBox(
              height: 30,
            ),
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
              isPasswordField: false,
              helperText: '',
            ),
            const SizedBox(
              height: 15,
            ),
            FormContainerWidget(
              controller: _passwordController,
              hintText: "Password",
              isPasswordField: true,
              helperText: '',
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                _signIn();
                showToast(message: "user is succesfully Loggin in");
              },
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 138, 60, 55),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: _isSigning
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Spage()),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Color.fromARGB(255, 130, 36, 36),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      showToast(message: "User is succsesfully signIn");
      Navigator.pushNamed(context, "/menupage");
    } else {
      showToast(message: "Some error happened");
    }
  }
}
