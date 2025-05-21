import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherHome(),
    );
  }
}

class WeatherHome extends StatefulWidget {
  @override
  _WeatherHomeState createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final String apiKey =
      '9b3b2a885607bf4720c40fa48ba1081b'; // Replace with your OpenWeatherMap API key
  String cityName = "Madurai"; // Default city name
  var temperature;
  var description;
  var weatherIcon;
  bool isLoading = false;
  String errorMessage = "";

  // Function to fetch weather data from the OpenWeatherMap API
  Future<void> fetchWeather() async {
    final String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var weatherData = json.decode(response.body);
        setState(() {
          temperature = weatherData['main']['temp'];
          description = weatherData['weather'][0]['description'];
          weatherIcon = weatherData['weather'][0]['icon'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load weather data. Status Code: ${response.statusCode}';
          isLoading = false;
        });
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather(); // Fetch weather data when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather of $cityName"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              CircularProgressIndicator() // Show loading spinner when fetching data
            else if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 18),
              )
            else if (temperature != null && description != null) ...[
              Text(
                '$temperature°C',
                style: TextStyle(fontSize: 40),
              ),
              Text(
                description,
                style: TextStyle(fontSize: 20),
              ),
              Image.network(
                  'http://openweathermap.org/img/wn/$weatherIcon@2x.png'),
            ],
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter City Name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                setState(() {
                  cityName = value;
                  fetchWeather(); // Fetch weather data for the new city
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
