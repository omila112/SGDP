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
    backgroundColor: Colors.grey[300],
    appBar: AppBar(
      backgroundColor: Color.fromARGB(255, 138, 60, 55),
      title: Text('Predictions'),
    ),
     // Background color for the whole scaffold
    body: ListView.builder(
      itemCount: matchedChemicalNames.length,
      itemBuilder: (context, index) {
        String chemicalName = matchedChemicalNames[index];
        Map<String, dynamic> predictionData = predictions[chemicalName];

        return Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0), // Add vertical spacing between chemicals
              decoration: BoxDecoration(
                color: Colors.white, // Set background color to white for the chemical section
                borderRadius: BorderRadius.circular(8.0), // Rounded border edges
                border: Border.all(color: Colors.grey), // Border around the whole section
              ),
              child: ExpansionTile(
                title: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    chemicalName,
                    style: TextStyle(fontSize: 16.0), // Adjust font size if needed
                  ),
                ),
                children: [
                  // Additional information revealed when the tile is expanded
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
              ),
            ),
          ],
        );
      },
    ),
  );
}


}
