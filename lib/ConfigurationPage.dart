import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  late DatabaseReference _databaseReference;
  bool _isMotorOn = false;
  double _selectedTimeInMinutes = 60.0; // Default to 60 minutes
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref().child('plant_health');
    _loadInitialValues();
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          _isMotorOn = data['motor'] ?? false;
          _selectedTimeInMinutes = (data['watering_time'] ?? 60).toDouble();
          _timeController.text = _selectedTimeInMinutes.toStringAsFixed(1);
        });
      }
    });
  }

  Future<void> _loadInitialValues() async {
    final snapshot = await _databaseReference.get();
    final data = snapshot.value as Map?;
    if (data != null) {
      setState(() {
        _isMotorOn = data['motor'] ?? false;
        _selectedTimeInMinutes = (data['watering_time'] ?? 60).toDouble();
        _timeController.text = _selectedTimeInMinutes.toStringAsFixed(1);
      });
    }
  }

  void _toggleMotor(bool? value) {
    setState(() {
      _isMotorOn = value ?? false;
    });
    _databaseReference.update({'motor': _isMotorOn});
  }

  void _updateWateringTime(double value) {
    setState(() {
      _selectedTimeInMinutes = value;
      _timeController.text =
          value.toStringAsFixed(1); // Update TextField with minutes
    });
    _databaseReference
        .update({'watering_time': _selectedTimeInMinutes}); // Store as minutes
  }

  void _updateWateringTimeFromText(String value) {
    final double? parsedValue = double.tryParse(value);
    if (parsedValue != null && parsedValue >= 0.1 && parsedValue <= 1140) {
      setState(() {
        _selectedTimeInMinutes = parsedValue;
        _timeController.text = parsedValue.toStringAsFixed(1);
      });
      _databaseReference.update({'watering_time': _selectedTimeInMinutes});
    } else {
      // Handle invalid input
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Invalid time value. Must be between 0.1 and 1140 minutes.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SwitchListTile(
              title: Text('Motor'),
              value: _isMotorOn,
              onChanged: _toggleMotor,
              activeColor: Colors.green, // Color when switch is on
              inactiveTrackColor: Colors.grey, // Track color when switch is off
              inactiveThumbColor:
                  Colors.white, // Thumb color when switch is off
            ),
            SizedBox(height: 20),
            Text(
                'Sensing Time: ${_selectedTimeInMinutes.toStringAsFixed(1)} minutes'),
            Slider(
              value: _selectedTimeInMinutes,
              min: 0.1,
              max: 1140.0,
              divisions: 11400, // Adjust divisions to match slider range
              label: _selectedTimeInMinutes.toStringAsFixed(1),
              onChanged: _updateWateringTime,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Enter Watering Time (minutes)',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1.0),
                ),
              ),
              onSubmitted: _updateWateringTimeFromText,
              inputFormatters: [
                // Ensure the TextField accepts values from 0.1 to 1140
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
