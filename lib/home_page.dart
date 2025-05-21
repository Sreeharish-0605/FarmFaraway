import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseReference _databaseReference;
  double plantHealth = 50;
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
          // Update plantHealth or other fields if necessary
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('FarmFarAway'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuration'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PlaceholderPage(title: 'Configuration'))),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('History'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlaceholderPage(title: 'History'))),
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('ChatBot'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlaceholderPage(title: 'ChatBot'))),
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
              height: screenHeight * 0.25, // Adjust height based on screen size
              child: ClipPath(
                clipper: CurvedTopClipper(),
                child: Container(
                  color: Colors.green,
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.8, // Responsive width
                      height: screenWidth * 0.8, // Responsive height
                      child: GestureDetector(
                        onTap: () {
                          // Remove SnackBar text on image click
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(content: Text('Image tapped!')),
                          // );
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://tse3.mm.bing.net/th?id=OIP.GrtlxZ6TrYNing_p-CjbBwAAAA&pid=Api&P=0&h=180'), // Replace with actual URL
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
                    SizedBox(
                        height:
                            16), // Add spacing between image and progress bars
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
                  heightFactor: value / 100,
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

class CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 100);
    var secondEndPoint = Offset(size.width, size.height - 50);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
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
