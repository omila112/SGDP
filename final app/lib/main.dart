import 'package:app/pages/first_page.dart';
import 'package:app/scanner/scannerapp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/home.dart';
import 'package:app/menupage.dart';
import 'package:app/pages/ex.dart';
import 'package:app/pages/ex1.dart';
import 'package:app/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyADu0ILeecXADfoAHrPXgPf1qA_nN5wyU0",
          appId: "1:484293598894:web:41079d6c140304b96d573f",
          messagingSenderId: "484293598894",
          projectId: "authenticator-6fb97"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  get matchedChemicalNames => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const FirstPage(), // Set Signin as the home pageasgSGagsgS
        routes: {
          //'/signin': (context) => Signin(),
          '/login': (context) => LoginPage(),
          '/menupage': (context) => const Menupage(),
          '/home': (context) => const HomePage(),
          '/ex': (context) => const page(), // Corrected route definition
          'ex1': (context) => const Spage(),
          'first_page': (context) => const FirstPage(),
          '/scannerapp': (context) => const App(),
        });
  }
}
//te3s
