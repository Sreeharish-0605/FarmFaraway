import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/HistoryPage.dart'; // Import HistoryPage
import 'package:myapp/ConfigurationPage.dart'; // Import ConfigurationPage
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3475475429.
import 'package:myapp/ChatBotPage.dart'; // Import ChatBotPage
import 'package:myapp/WeatherApp.dart';
import 'package:myapp/map.dart';
import 'package:myapp/IrrigationCalculatorApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(FarmFarAwayApp());
}

class FarmFarAwayApp extends StatefulWidget {
  @override
  _FarmFarAwayAppState createState() => _FarmFarAwayAppState();
}

class _FarmFarAwayAppState extends State<FarmFarAwayApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmFarAway',
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      home: HomePage(
        onThemeToggle: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
      routes: {
        '/history': (context) => HistoryPage(), // Add route for HistoryPage
        '/configuration': (context) =>
            ConfigurationPage(), // Add route for ConfigurationPage
        '/chatbot': (context) => ChatBotPage(),
        '/weather': (context) => WeatherApp(),
        '/map': (context) => FarmMapPage(),
        '/calculator': (context) =>
          IrrigationCalculatorApp(), // Add route for WeatherPage'
      },
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  ThemeData get _lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.green,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green,
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
          .copyWith(secondary: Colors.orange),
    );
  }

  ThemeData get _darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      //primarySwatch: Color.fromARGB(255, 100, 135, 101),
      appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(149, 0, 0, 0),
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      scaffoldBackgroundColor: Color.fromARGB(255, 102, 134, 96),
      //colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
      //.copyWith(secondary: Colors.orange),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  HomePage({required this.onThemeToggle, required this.isDarkMode});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseReference _databaseReference;
  double moistureLevel = 50;
  double temperatureLevel = 50;
  double humidityLevel = 50;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref();
    _databaseReference.child('plant_health').onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          moistureLevel = (data['moisture'] ?? 50).toDouble();
          temperatureLevel = (data['temperature'] ?? 50).toDouble();
          humidityLevel = (data['humidity'] ?? 50).toDouble();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FarmFarAway'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
              ),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.sunny),
              title: Text('Weather'),
              onTap: () => Navigator.pushNamed(context, '/weather'),
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Map'),
              onTap: () => Navigator.pushNamed(context, '/map'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuration'),
              onTap: () => Navigator.pushNamed(
                  context, '/configuration'), // Navigate to ConfigurationPage
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('History'),
              onTap: () => Navigator.pushNamed(
                  context, '/history'), // Navigate to HistoryPage
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('ChatBot'),
              onTap: () => Navigator.pushNamed(context, '/chatbot'),
            ),
            ListTile(
              leading: Icon(Icons.water_drop_rounded),
              title: Text('Irrig Calculator'),
              onTap: () => Navigator.pushNamed(context, '/calculator'),
            ),
            ListTile(
              leading: Icon(Icons.build),
              title: Text('Testing'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 200,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Text(
                  'FarmFarAway',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: GestureDetector(
                        onTap: () {},
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://tse3.mm.bing.net/th?id=OIP.GrtlxZ6TrYNing_p-CjbBwAAAA&pid=Api&P=0&h=180'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildProgressBar(
                            'Moisture', moistureLevel, Colors.green),
                        _buildProgressBar(
                            'Temperature', temperatureLevel, Colors.orange),
                        _buildProgressBar(
                            'Humidity', humidityLevel, Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(
          width: 60,
          height: 150,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Positioned.fill(
                child: FractionallySizedBox(
                  heightFactor: (value > 0
                      ? value / 100
                      : 0.01), // Ensure heightFactor is never 0
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text('${value.toStringAsFixed(1)}%'),
      ],
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('$title Page Content',
            style: TextStyle(fontSize: 18, color: Colors.black54)),
      ),
    );
  }
}
