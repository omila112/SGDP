import 'package:flutter/material.dart';

class PredictionsDisplayScreen extends StatelessWidget {
  final List<String> matchedChemicalNames;
  final Map<String, dynamic> predictions;

  const PredictionsDisplayScreen({
    Key? key,
    required this.matchedChemicalNames,
    required this.predictions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predictions'),
      ),
      body: ListView.builder(
        itemCount: matchedChemicalNames.length,
        itemBuilder: (context, index) {
          String chemicalName = matchedChemicalNames[index];
          Map<String, dynamic> predictionData = predictions[chemicalName];

          return ExpansionTile(
  title: Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey), // Border around the chemical name
    ),
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        chemicalName,
        style: TextStyle(fontSize: 16.0), // Adjust font size if needed
      ),
    ),
  ),
  children: [
    // Content revealed when the tile is expanded
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Health Hazards: ${predictionData['Health Hazards']}'),
          Text('Additional Information: ${predictionData['Additional Information']}'),
          Text('Compounds: ${predictionData['Compounds']}'),
        ],
      ),
    ),
  ],
);

        },
      ),
    );
  }
}
