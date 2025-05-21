import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Add this dependency for color picking
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart'; // Add this dependency for local storage

class FarmMapPage extends StatefulWidget {
  @override
  _FarmMapPageState createState() => _FarmMapPageState();
}

class _FarmMapPageState extends State<FarmMapPage> {
  List<Offset> points = [];
  Offset shelter1 = Offset(50, 550); // Shelter 1 (bottom-left)
  Offset shelter2 = Offset(350, 50); // Shelter 2 (top-right)
  bool isShelter2Clicked = false;
  Color shelter1Color = Colors.blue;
  Color shelter2Color = Colors.blue;
  Color pathColor = Colors.green[700]!;
  Color pointColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _loadMapState();
  }

  Future<void> _loadMapState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      points = _decodePoints(prefs.getString('points') ?? '');
      shelter1Color = Color(prefs.getInt('shelter1Color') ?? Colors.blue.value);
      shelter2Color = Color(prefs.getInt('shelter2Color') ?? Colors.blue.value);
      pathColor = Color(prefs.getInt('pathColor') ?? Colors.green[700]!.value);
      pointColor = Color(prefs.getInt('pointColor') ?? Colors.red.value);
      isShelter2Clicked = prefs.getBool('isShelter2Clicked') ?? false;
    });
  }

  Future<void> _saveMapState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('points', _encodePoints(points));
    await prefs.setInt('shelter1Color', shelter1Color.value);
    await prefs.setInt('shelter2Color', shelter2Color.value);
    await prefs.setInt('pathColor', pathColor.value);
    await prefs.setInt('pointColor', pointColor.value);
    await prefs.setBool('isShelter2Clicked', isShelter2Clicked);
  }

  String _encodePoints(List<Offset> points) {
    return points.map((p) => '${p.dx},${p.dy}').join(';');
  }

  List<Offset> _decodePoints(String encoded) {
    if (encoded.isEmpty) return [];
    return encoded.split(';').map((s) {
      final parts = s.split(',');
      return Offset(double.parse(parts[0]), double.parse(parts[1]));
    }).toList();
  }

  void resetMap() {
    setState(() {
      points.clear();
      isShelter2Clicked = false;
    });
    _saveMapState(); // Save the reset state
  }

  void showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  color: shelter1Color,
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 10),
                Text('Shelter 1'),
                IconButton(
                  icon: Icon(Icons.color_lens),
                  onPressed: () => _selectColor((color) {
                    setState(() {
                      shelter1Color = color;
                    });
                    _saveMapState(); // Save the selected color
                  }),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  color: shelter2Color,
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 10),
                Text('Shelter 2'),
                IconButton(
                  icon: Icon(Icons.color_lens),
                  onPressed: () => _selectColor((color) {
                    setState(() {
                      shelter2Color = color;
                    });
                    _saveMapState(); // Save the selected color
                  }),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  color: pathColor,
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 10),
                Text('Path'),
                IconButton(
                  icon: Icon(Icons.color_lens),
                  onPressed: () => _selectColor((color) {
                    setState(() {
                      pathColor = color;
                    });
                    _saveMapState(); // Save the selected color
                  }),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  color: pointColor,
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 10),
                Text('User Points'),
                IconButton(
                  icon: Icon(Icons.color_lens),
                  onPressed: () => _selectColor((color) {
                    setState(() {
                      pointColor = color;
                    });
                    _saveMapState(); // Save the selected color
                  }),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _selectColor(ValueChanged<Color> onColorSelected) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pick a Color'),
        content: ColorPicker(
          pickerColor: Colors.blue,
          onColorChanged: onColorSelected,
          showLabel: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void onTapDown(TapDownDetails details) {
    final tappedPoint = details.localPosition;

    if (points.isEmpty) {
      setState(() {
        points.add(shelter1);
        points.add(tappedPoint);
      });
    } else if ((tappedPoint - shelter2).distance < 20) {
      setState(() {
        points.add(shelter2);
        isShelter2Clicked = true;
      });
      _saveMapState(); // Save the state when shelter2 is clicked
    } else if (!isShelter2Clicked) {
      setState(() {
        points.add(tappedPoint);
        // Check if the last point is near shelter1 or shelter2
        if ((points.last - shelter1).distance < 20 ||
            (points.last - shelter2).distance < 20) {
          _saveMapState(); // Save the state only if the path ends with a shelter
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farm Map'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: showInfoDialog, // Info button to show the popup
          )
        ],
      ),
      body: GestureDetector(
        onTapDown: onTapDown,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/farm_field.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: CustomPaint(
                painter: FarmPainter(
                  points: points,
                  shelter1: shelter1,
                  shelter2: shelter2,
                  shelter1Color: shelter1Color,
                  shelter2Color: shelter2Color,
                  pathColor: pathColor,
                  pointColor: pointColor,
                ),
                child: Container(),
              ),
            ),
            if (isShelter2Clicked)
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: resetMap,
                  child: Icon(Icons.refresh),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FarmPainter extends CustomPainter {
  final List<Offset> points;
  final Offset shelter1;
  final Offset shelter2;
  final Color shelter1Color;
  final Color shelter2Color;
  final Color pathColor;
  final Color pointColor;

  FarmPainter({
    required this.points,
    required this.shelter1,
    required this.shelter2,
    required this.shelter1Color,
    required this.shelter2Color,
    required this.pathColor,
    required this.pointColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pathPaint = Paint()
      ..color = pathColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    final pointPaint = Paint()
      ..color = pointColor
      ..style = PaintingStyle.fill;

    final shelterPaint = Paint()
      ..color = shelter1Color
      ..style = PaintingStyle.fill;

    // Draw shelter1 and shelter2 with icons
    _drawShelterWithIcon(canvas, shelter1, Paint()..color = shelter1Color);
    _drawShelterWithIcon(canvas, shelter2, Paint()..color = shelter2Color);

    // Draw points and connecting lines
    if (points.isNotEmpty) {
      List.generate(points.length - 1, (i) {
        canvas.drawLine(points[i], points[i + 1], pathPaint);
      });
      for (var point in points) {
        canvas.drawCircle(point, 8, pointPaint);
      }
    }
  }

  void _drawShelterWithIcon(Canvas canvas, Offset shelter, Paint paint) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.home.codePoint),
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: Icons.home.fontFamily,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    canvas.drawCircle(shelter, 15, paint);
    textPainter.paint(canvas, shelter.translate(-10, -10));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
