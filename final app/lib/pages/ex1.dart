import 'package:app/global/toast.dart';
import 'package:app/pages/ex.dart';
import 'package:app/pages/form_container_widget.dart';
import 'package:app/user_auth/firebase_auth_ser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Spage extends StatefulWidget {
  const Spage({Key? key}) : super(key: key);

  @override
  State<Spage> createState() => _SpageState();
}

class _SpageState extends State<Spage> {
  bool _isSigninUp = false;

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "SignUp",
              style: TextStyle(
                  fontSize: 43,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 22, 3, 2)),
            ),
            const SizedBox(
              height: 30,
            ),
            //username................................
            FormContainerWidget(
              controller: _usernameController,
              hintText: "Username",
              isPasswordField: false,
              helperText: '',
            ),
            const SizedBox(
              height: 10,
            ),
            //email.....................................
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
              isPasswordField: false,
              helperText: '',
            ),
            const SizedBox(
              height: 10,
            ),
            //password...................................
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
                _signup();
                showToast(message: "user is succesfully created");
              },
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 138, 60, 55),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: _isSigninUp
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "SignUp",
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
                  "Already have an account ?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const page()));
                  },
                  child: const Text(
                    "Login",
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

  void _signup() async {
    setState(() {
      _isSigninUp = true;
    });

    // ignore: unused_local_variable
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      _isSigninUp = false;
    });

    if (user != null) {
      showToast(message: "User is successfully created");
      Navigator.pushNamed(context, "/menupage");
    } else {
      showToast(message: "Some error happened");
    }
  }
}
