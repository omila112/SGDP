import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Python Communication',
      home: InputPage(),
    );
  }
}

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  TextEditingController _textController = TextEditingController();

  Future<void> sendDataToPython(String input) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://127.0.0.1:3010'), // Replace with your Python server address
        body: {'input': input},
      );

      if (response.statusCode == 200) {
        print('Data sent successfully to Python.');
      } else {
        print('Failed to send data to Python: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending data to Python: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Python Communication'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Enter your message',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  String input = _textController.text;
                  if (input.isNotEmpty) {
                    sendDataToPython(input);
                    _textController.clear();
                  } else {
                    // Handle empty input
                  }
                },
                child: Text('Send Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
