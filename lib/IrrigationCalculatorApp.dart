import 'package:flutter/material.dart';

class IrrigationCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Irrigation Water Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WaterCalculatorScreen(),
    );
  }
}

class WaterCalculatorScreen extends StatefulWidget {
  @override
  _WaterCalculatorScreenState createState() => _WaterCalculatorScreenState();
}

class _WaterCalculatorScreenState extends State<WaterCalculatorScreen> {
  final TextEditingController _soilMoistureController = TextEditingController();
  final TextEditingController _targetSoilMoistureController = TextEditingController();
  final TextEditingController _fieldAreaController = TextEditingController();
  final TextEditingController _cropWaterRequirementController = TextEditingController();

  String _selectedWeather = 'Sunny'; // Default weather condition
  String _waterRequired = '';

  // Function to calculate water required
  void _calculateWaterRequired() {
    double soilMoisture = double.tryParse(_soilMoistureController.text) ?? 0.0;
    double targetSoilMoisture = double.tryParse(_targetSoilMoistureController.text) ?? 0.0;
    double fieldArea = double.tryParse(_fieldAreaController.text) ?? 0.0;
    double cropWaterRequirement = double.tryParse(_cropWaterRequirementController.text) ?? 0.0;

    // Check if inputs are valid
    if (soilMoisture > 0 && targetSoilMoisture > 0 && fieldArea > 0 && cropWaterRequirement > 0) {
      // Calculate the base water requirement
      double moistureDifference = (targetSoilMoisture - soilMoisture) / 100;
      double baseWaterRequired = fieldArea * moistureDifference * cropWaterRequirement;

      // Apply weather factor
      double weatherFactor = 1.0;
      if (_selectedWeather == 'Sunny') {
        weatherFactor = 1.2; // Increase by 20% if sunny
      } else if (_selectedWeather == 'Rainy') {
        weatherFactor = 0.7; // Decrease by 30% if rainy
      }

      // Final water required after considering weather
      double waterRequired = baseWaterRequired * weatherFactor;

      setState(() {
        _waterRequired = waterRequired.toStringAsFixed(2) + ' liters';
      });
    } else {
      setState(() {
        _waterRequired = 'Invalid input';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Irrigation Water Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Soil Moisture Input
            TextField(
              controller: _soilMoistureController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Current Soil Moisture (%)',
              ),
            ),

            // Target Soil Moisture Input
            TextField(
              controller: _targetSoilMoistureController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Target Soil Moisture (%)',
              ),
            ),

            // Field Area Input
            TextField(
              controller: _fieldAreaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Field Area (m²)',
              ),
            ),

            // Crop Water Requirement Input
            TextField(
              controller: _cropWaterRequirementController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Crop Water Requirement (liters/m²)',
              ),
            ),

            // Weather Condition Dropdown
            DropdownButton<String>(
              value: _selectedWeather,
              items: <String>['Sunny', 'Rainy', 'Neutral'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedWeather = newValue!;
                });
              },
              hint: Text('Select Weather Condition'),
            ),

            SizedBox(height: 20),

            // Calculate Button
            ElevatedButton(
              onPressed: _calculateWaterRequired,
              child: Text('Calculate Water Required'),
            ),

            SizedBox(height: 20),

            // Output
            Text(
              'Water Required: $_waterRequired',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
