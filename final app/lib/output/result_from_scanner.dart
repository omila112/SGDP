import 'package:flutter/material.dart';

class ResultsDisplayScreen extends StatelessWidget {
  final List<String> matchedChemicalNames;

  const ResultsDisplayScreen({Key? key, required this.matchedChemicalNames})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matched Chemical Names'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: matchedChemicalNames.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(matchedChemicalNames[index]),
            );
          },
        ),
      ),
    );
  }
}
