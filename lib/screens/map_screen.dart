import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final List<Event> events;

  MapScreen({required this.events});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _initialPosition = LatLng(37.7749, -122.4194); // Example location
  final Set<Marker> _markers = {};
  Event? _selectedEvent; // Store the selected event for the bottom sheet

  @override
  void initState() {
    super.initState();
    _addEventMarkers();
  }

  void _addEventMarkers() {
    for (var event in widget.events) {
      _markers.add(
        Marker(
          markerId: MarkerId(event.name),
          position: LatLng(event.latitude, event.longitude),
          onTap: () {
            setState(() {
              _selectedEvent = event; // Set the selected event
            });
          },
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12.0,
            ),
            markers: _markers,
          ),
          if (_selectedEvent != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildEventDetailsSheet(),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          // Handle navigation logic
        },
      ),
    );
  }

  Widget _buildEventDetailsSheet() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedEvent!.name, // Event name
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            _selectedEvent!.description, // Event description
            style: TextStyle(fontSize: 14.0),
          ),
          SizedBox(height: 8.0),
          Text(
            "Location: ${_selectedEvent!.latitude}, ${_selectedEvent!.longitude}", // Show latitude and longitude
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to event details screen
                },
                child: Text('View Details'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEvent = null; // Close the bottom sheet
                  });
                },
                child: Text('Close'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Event {
  final String name;
  final String description;
  final double latitude;
  final double longitude;

  Event({
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
  });
}
