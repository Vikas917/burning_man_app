import 'package:burning_man_app/home_page.dart';
import 'package:burning_man_app/home_screens.dart';
import 'package:burning_man_app/map_screens.dart';
import 'package:burning_man_app/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'google_map.dart'; // Import your GoogleMapScreen class

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Burning Man App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage()// Set the GoogleMapScreen widget as the home screen
    );
  }
}
