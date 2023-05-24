import 'package:flutter/material.dart';

class NewDataPage extends StatefulWidget {
  const NewDataPage({super.key});

  @override
  State<NewDataPage> createState() => _NewDataPageState();
}

class _NewDataPageState extends State<NewDataPage> {
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();

  double _heightValue=0.0;
  double _weightValue=0.0;
  String _heartRate = '';

  void _acquireHeartRate() {
    
    setState(() {
      _heartRate = 'Acquired heart rate';
    });
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insert the new data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Height (cm)'),
                onChanged: (value) {
                  setState(() {
                    _heightValue = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                onChanged: (value) {
                  setState(() {
                    _weightValue = double.tryParse(value)?? 0.0;
                  });
                },
              ),
              SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _acquireHeartRate,
              child: Text('Acquire Heart Rate data'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Heart Rate: $_heartRate',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}