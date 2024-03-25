import 'package:app/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePagee extends StatefulWidget {
  const HomePagee({Key? key}) : super(key: key);

  @override
  State<HomePagee> createState() => _HomePageState();
}

class _HomePageState extends State<HomePagee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 138, 60, 55),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 25,
            ),

            // Shop name
            Text(
              "COSMO SCAN",
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 28,
                color: Colors.white,
              ),
            ),

            // Icon
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Image.asset('lib/app images/cosmetics.png'),
            ),

            // Title
            Text(
              "LETS'S SCAN CHEMICALS IN COSMETICS",
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 28,
                color: Colors.white,
              ),
            ),

            // Subtitle
            Text(
              "scan your cosmetics to find out what chemicals to use or not, let's be healthy",
              style: GoogleFonts.dmSerifDisplay(
                height: 2,
                color: Colors.grey,
              ),
            ),

            // Get started button
            MyButton(
              text: "Get Started",
              onTap: () {
                //go to the menu page
                Navigator.pushNamed(context, '/menupage');
              },
            )
          ],
        ),
      ),
    );
  }
}
