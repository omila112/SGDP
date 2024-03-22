import 'package:app/output/info_of_chem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultsDisplayScreen extends StatelessWidget {
  final List<String> matchedChemicalNames;

  const ResultsDisplayScreen({Key? key, required this.matchedChemicalNames})
      : super(key: key);

  Future<void> _getPredictions(BuildContext context) async {
    final url = 'http://192.168.39.140:9000/predict'; // Updated endpoint
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'MatchedChemicalNames': matchedChemicalNames}),
    );

    if (response.statusCode == 200) {
      print('Server response: ${response.body}'); // Print server response
      Map<String, dynamic> predictions = jsonDecode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PredictionsDisplayScreen(
            matchedChemicalNames: matchedChemicalNames,
            predictions: predictions,
          ),
        ),
      );
    } else {
      print('Failed to fetch predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harmful chemicals'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: matchedChemicalNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(matchedChemicalNames[index]),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _getPredictions(context);
            },
            child: Text('Tap to get more info about chemicals'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
