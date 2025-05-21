import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late DatabaseReference _databaseReference;
  Map<String, List<double>> data = {
    'moisture': [],
    'temperature': [],
    'humidity': []
  };

  @override
  void initState() {
    super.initState();
    _databaseReference =
        FirebaseDatabase.instance.ref().child('plant_health/History');
    _databaseReference.onValue.listen((event) {
      final dataSnapshot = event.snapshot.value as Map?;
      if (dataSnapshot != null) {
        setState(() {
          data = {'moisture': [], 'temperature': [], 'humidity': []};
          dataSnapshot.forEach((key, value) {
            if (value is Map) {
              final double? humidity = _parseToDouble(value['humidity']);
              final double? moisture = _parseToDouble(value['moisture']);
              final double? temperature = _parseToDouble(value['temperature']);

              if (humidity != null) data['humidity']!.add(humidity);
              if (moisture != null) data['moisture']!.add(moisture);
              if (temperature != null) data['temperature']!.add(temperature);
            }
          });
        });
      }
    });
  }

  double? _parseToDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value);
    } else if (value is num) {
      return value.toDouble();
    }
    return null;
  }

  double _calculateAverage(List<double> values) {
    if (values.isEmpty) return 0.0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBarChart(),
            _buildPieChart(),
            _buildDataTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: _calculateAverage(data['moisture']!),
                  color: Colors.green,
                  width: 20,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: _calculateAverage(data['temperature']!),
                  color: Colors.orange,
                  width: 20,
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: _calculateAverage(data['humidity']!),
                  color: Colors.blue,
                  width: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final totalMoisture = _calculateAverage(data['moisture']!);
    final totalTemperature = _calculateAverage(data['temperature']!);
    final totalHumidity = _calculateAverage(data['humidity']!);

    final total = totalMoisture + totalTemperature + totalHumidity;

    return Container(
      height: 300,
      padding: EdgeInsets.all(16.0),
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.green,
              value: total == 0 ? 0 : (totalMoisture / total) * 100,
              title: 'Moisture',
            ),
            PieChartSectionData(
              color: Colors.orange,
              value: total == 0 ? 0 : (totalTemperature / total) * 100,
              title: 'Temperature',
            ),
            PieChartSectionData(
              color: Colors.blue,
              value: total == 0 ? 0 : (totalHumidity / total) * 100,
              title: 'Humidity',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: DataTable(
        columns: [
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Average Value')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Moisture')),
            DataCell(Text(
                '${_calculateAverage(data['moisture']!).toStringAsFixed(2)}')),
          ]),
          DataRow(cells: [
            DataCell(Text('Temperature')),
            DataCell(Text(
                '${_calculateAverage(data['temperature']!).toStringAsFixed(2)}')),
          ]),
          DataRow(cells: [
            DataCell(Text('Humidity')),
            DataCell(Text(
                '${_calculateAverage(data['humidity']!).toStringAsFixed(2)}')),
          ]),
        ],
      ),
    );
  }
}
