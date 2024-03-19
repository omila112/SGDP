import 'dart:async';
import 'package:app/output/result_from_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class ResultScreen extends StatelessWidget {
  final String text;
  final BuildContext context;

  const ResultScreen({Key? key, required this.text, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Result',
            style: TextStyle(color: Colors.white, fontSize: 27),
          ),
          backgroundColor: Color.fromARGB(
            255,
            138,
            60,
            55,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30.0),
                child: Text(text),
              ),
              ElevatedButton(
                onPressed: () {
                  // Call the function to add data to Firestore and send to the server
                  addToFirestoreandSendToServer(text);
                },
                child: Text('Add to Firestore and send to server'),
              ),
            ],
          ),
        ),
      );

  // Method to add data to Firestore and send to the server
  void addToFirestoreandSendToServer(String text) async {
    String documentId = await addFieldToRandomDocument(text);
    sendHttpRequest(text);
  }

  Future<String> addFieldToRandomDocument(String text) async {
    // Get a reference to the Firestore collection
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('scanned_data');

    // Generate a random document ID
    String randomDocumentId = generateRandomDocumentId();

    // Set the field name and value
    String fieldName = 'chemical';
    dynamic fieldValue = text;

    // Add the document to Firestore
    await collectionReference
        .doc(randomDocumentId)
        .set({fieldName: fieldValue});

    return randomDocumentId; // Return the generated document ID
  }

  String generateRandomDocumentId() {
    // Generate a random alphanumeric string for the document ID
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    const length = 4; // Adjust the length as per your requirement
    Random random = Random();
    String randomId = '';

    for (int i = 0; i < length; i++) {
      randomId += chars[random.nextInt(chars.length)];
    }

    return randomId;
  }

  // Method to send HTTP request to server
  void sendHttpRequest(String text) async {
    print('Text to be sent to server: $text');

    // Encode the text properly based on how it's expected by the server
    String encodedText = jsonEncode({'Query': text});
    print('Encoded text: $encodedText');

    final url = 'http://192.168.1.5:9000/api'; // Remove query parameter
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'Query': text}),
    );

   if (response.statusCode == 200) {
      List<String> matchedChemicalNames = List<String>.from(jsonDecode(response.body)["MatchedChemicalNames"]);
      Navigator.push(
        // Navigate to the results display screen
        context,
        MaterialPageRoute(
          builder: (context) => ResultsDisplayScreen(matchedChemicalNames: matchedChemicalNames),
        ),
      );
    } else {
      print('Failed to send HTTP request');
    }
  }
}
