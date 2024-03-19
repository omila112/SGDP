import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _HomePageState();
}

class _HomePageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
    // Add a delay of 3 seconds before navigating to the home page
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/ex');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 138, 60, 55),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Shop name
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "COSMO SCAN",
                  style: GoogleFonts.dmSans(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: 0),

              // Icon
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Image.asset(
                  'lib/app images/skincare.png',
                  width: 400, // Set the desired width
                  height: 200, // Set the desired height
                ),
              ),

              SizedBox(height: 10),

              // Title
              GestureDetector(
                child: Text(
                  "LETS'S SCAN CHEMICALS IN COSMETICS",
                  style: GoogleFonts.dmMono(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
