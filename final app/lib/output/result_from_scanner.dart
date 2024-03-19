import 'package:flutter/material.dart';

class ResultsDisplayScreen extends StatelessWidget {
  final List<String> matchedChemicalNames;

  const ResultsDisplayScreen({Key? key, required this.matchedChemicalNames})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harmful chemicals in the product'),
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
            onPressed: () {},
            child: Text('Tap to get more info about chemicals'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
