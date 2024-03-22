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
      title: Text(
    'Predictions',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),),
    ),
    body: ListView.builder(
      itemCount: matchedChemicalNames.length,
      itemBuilder: (context, index) {
        String chemicalName = matchedChemicalNames[index];
        Map<String, dynamic> predictionData = predictions[chemicalName];

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Add padding around the chemical section
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0), // Rounded border edges
              border: Border.all(color: Colors.white), // Border around the whole section
            ),
            child: ExpansionTile(
              title: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  chemicalName,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold), // Bold font for chemical name
                ),
              ),
              children: [
                // Additional information revealed when the tile is expanded
               Padding(
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: 'Health Hazards: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '${predictionData['Health Hazards']}'),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: 'Additional Information: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '${predictionData['Additional Information']}'),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: 'Compounds: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '${predictionData['Compounds']}'),
          ],
        ),
      ),
    ],
  ),
),

              ],
            ),
          ),
        );
      },
    ),
  );
}


}
