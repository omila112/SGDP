import 'package:flutter/material.dart';

class PredictionsScreen extends StatelessWidget {
  final Map<String, dynamic> predictions;

  const PredictionsScreen({Key? key, required this.predictions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predicted Information'),
      ),
      body: ListView(
        children: predictions.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Health Hazards: ${entry.value['Health Hazards']}'),
                Text(
                    'Additional Information: ${entry.value['Additional Information']}'),
                Text('Compounds: ${entry.value['Compounds']}'),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
