import 'package:burning_man_app/calender_page.dart';
import 'package:burning_man_app/now_page.dart';
import 'package:burning_man_app/tabs_event_page.dart';
import 'package:burning_man_app/tabs_page.dart';
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
    TabsPage(),
    EventsPage(),
    //FavoritesPage(favoriteEventIds: {}, events: [], onFavoriteToggle: (int eventId) {}),
    CalendarPage(events: []),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.deepOrangeAccent,
      //   title: const Text("BurnTech"),
      //   centerTitle: true,
      // ),
      body: _pages[_currentIndex], // Show the current screen
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.red[50],
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) {
              bool isSelected = _currentIndex == index;
              List<IconData> icons = [
                Icons.map,
                Icons.access_time,
                Icons.list,
                Icons.event,
                Icons.calendar_today,
              ];
              List<String> labels = ["Map", "Now", "Browse", "Events", "Calendar"];

              return Expanded(
                child: GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon Container with Animation
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: isSelected ? EdgeInsets.symmetric(horizontal: 18, vertical: 2) : EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.deepOrangeAccent : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AnimatedSize(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Icon(
                            icons[index],
                            color: isSelected ? Colors.black : Colors.orangeAccent,
                            size: isSelected ? 30 : 26,
                          ),
                        ),
                      ),
                      // Fixed Text below the Icon
                      SizedBox(height: 5), // Space between icon and text
                      Text(
                        labels[index],
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),

    );
  }
}


class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  void _focusOnLocation() {
    _mapController.move(LatLng(40.7864, -119.2065), 16.0); // Move and zoom
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController, // Attach controller
            options: MapOptions(
              initialCenter: LatLng(40.7864, -119.2065),
              initialZoom: 15.0,
              maxZoom: 18.0,
              minZoom: 10.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(
                markers: [
                  // User Location Marker
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(40.7979, -119.1995),
                    child: Icon(Icons.location_on, color: Colors.red, size: 40.0),
                  ),

                  // Hospital Marker
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(40.7900, -119.2000),
                    child: Icon(Icons.local_hospital, color: Colors.red, size: 40.0),
                  ),

                  // Camp Marker
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(40.7935, -119.2070),
                    child: Icon(Icons.campaign, color: Colors.green, size: 40.0),
                  ),

                  // Restaurant Marker
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(40.7850, -119.2150),
                    child: Icon(Icons.restaurant, color: Colors.orange, size: 40.0),
                  ),

                  // Park Marker
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(40.7880, -119.2120),
                    child: Icon(Icons.nature_people, color: Colors.greenAccent, size: 40.0),
                  ),

                  // === Opposite Side Markers ===

                  // Gas Station Marker (Opposite Side)
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(40.7750, -119.1850), // Opposite direction
                    child: Icon(Icons.local_gas_station, color: Colors.yellow, size: 40.0),
                  ),

                  // Shopping Area Marker (Opposite Side)
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(40.7780, -119.1900), // Opposite direction
                    child: Icon(Icons.shop, color: Colors.pink, size: 40.0),
                  ),

                  // Police Station Marker (Opposite Side)
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(40.785847851221, -119.21107722177), // Opposite direction
                    child: Icon(Icons.local_police, color: Colors.indigo, size: 40.0),
                  ),

                  // Fire Department Marker (Opposite Side)
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(40.78318389, -119.20212034870), // Opposite direction
                    child: Icon(Icons.local_fire_department, color: Colors.red, size: 40.0),
                  ),
                ],
              )


            ],
          ),

          // Styled text label with an icon inside
          Positioned(
            top: 55,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _focusOnLocation, // Tap to focus
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.gps_fixed, color: Colors.deepOrangeAccent, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Outside Black Rock City",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 8),

                // Second icon below the text
                GestureDetector(
                  onTap: _focusOnLocation, // Tap to focus
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                    ),
                    child: Icon(Icons.location_pin, color: Colors.deepOrangeAccent, size: 30),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
