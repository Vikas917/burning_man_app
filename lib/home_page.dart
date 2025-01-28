import 'package:burning_man_app/calender_page.dart';
import 'package:burning_man_app/now_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:burning_man_app/event_screen.dart'; // Import your EventsPage
import 'package:burning_man_app/favorites_screen.dart'; // Import your FavoritesPage
import 'package:burning_man_app/search_event_page.dart'; // Import your SearchPage

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Default screen is MapPage

  // Function to handle navigation to other pages
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // List of pages for the bottom navigation bar
  final List<Widget> _pages = [
    MapPage(),
    NowPage(),
    EventsPage(),
    FavoritesPage(favoriteEventIds: {}, events: [], onFavoriteToggle: (int eventId) {}),
    CalendarPage(events: []),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Show the current screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrangeAccent,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Now'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Faves'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
        ],
      ),
    );
  }
}

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(40.7864, -119.2065), // Coordinates for Black Rock City
        initialZoom: 15.0,
        maxZoom: 18.0,
        minZoom: 10.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
    MarkerLayer(
    markers: [
    // Location marker
    Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(40.7864, -119.2065),
    child: Container(
    child: Icon(
    Icons.location_on,
    color: Colors.redAccent,
    size: 40.0,
    ),
    ),
    ),

    // Hospital marker
    Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(40.7900, -119.2000),
    child: Container(
    child: Icon(
    Icons.local_hospital,
    color: Colors.red,
    size: 40.0,
    ),
    ),
    ),

    // Camp marker
    Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(40.7935, -119.2070),
    child: Container(
    child: Icon(
    Icons.campaign,
    color: Colors.green,
    size: 40.0,
    ),
    ),
    ),

    // Restaurant marker
    Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(40.7850, -119.2150),
    child: Container(
    child: Icon(
    Icons.restaurant,
    color: Colors.orange,
    size: 40.0,
    ),
    ),
    ),

    // Park marker
    Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(40.7880, -119.2120),
    child: Container(
    child: Icon(
    Icons.nature_people,
    color: Colors.greenAccent,
    size: 40.0,
    ),
    ),
    ),

      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(40.7870, -119.2035),
        child: Container(
          child: Icon(
            Icons.local_gas_station,
            color: Colors.yellow,
            size: 40.0,
          ),
        ),
      ),

      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(40.7940, -119.2030),
        child: Container(
          child: Icon(
            Icons.shop,
            color: Colors.pink,
            size: 40.0,
          ),
        ),
      ),

      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(40.7970, -119.2025),
        child: Container(
          child: Icon(
            Icons.local_police,
            color: Colors.indigo,
            size: 40.0,
          ),
        ),
      ),

      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(40.7900, -119.2020),
        child: Container(
          child: Icon(
            Icons.local_fire_department,
            color: Colors.red,
            size: 40.0,
          ),
        ),
      ),

    ],


    )
    ],
    );
  }
}