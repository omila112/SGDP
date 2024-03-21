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

          return ListTile(
            title: Text(chemicalName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Health Hazards: ${predictionData['Health Hazards']}'),
                Text(
                    'Additional Information: ${predictionData['Additional Information']}'),
                Text('Compounds: ${predictionData['Compounds']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
