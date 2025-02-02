import 'dart:convert';
import 'package:burning_man_app/marker_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MapScreens extends StatefulWidget {
  const MapScreens({super.key});

  @override
  State<MapScreens> createState() => _MapScreensState();
}

class _MapScreensState extends State<MapScreens> {
  final MapController _mapController = MapController();
  List<MarkerData> _markerData = [];
  List<Marker> _markers = [];
  LatLng? _selectedPosition;
  LatLng? _myLocation;
  LatLng? _draggedPosition;
  bool _isDragging = false;
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  //get Current Location
  Future<Position> _determinePosition() async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) {
      return Future.error("Location services are disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location services are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location services are denied forever");
    }

    return await Geolocator.getCurrentPosition();
  }

  //Show current location
  void _showCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      _mapController.move(currentLatLng, 15.0);
      setState(() {
        _myLocation = currentLatLng;
      });
    } catch(e) {
      print(e);
    }
  }

  //Add marker on selected position
  void _addMarker(LatLng position, String title, String description) {
    setState(() {
      final markerData = MarkerData(position: position, title: title, description: description);
      _markerData.add(markerData);
      _markers.add(
          Marker(
              point: position,
              width: 80,
              height: 80,
              child: GestureDetector(
                onTap: () => _showMarkerInfo(markerData),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.redAccent,
                          size: 40,
                        ),
                      ),
                    ],
                  )
              )
          )
      );
      _saveMarkers(); // Save markers after adding them
    });
  }

  //Show Marker dialog
  void _showMarkerDialog(BuildContext context, LatLng position) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Add Marker",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrangeAccent,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _addMarker(position, titleController.text, descController.text);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        )
    );
  }

  // Delete marker function
  void _deleteMarker(MarkerData markerData) {
    setState(() {
      // Remove marker from _markerData and _markers
      _markerData.removeWhere((item) => item == markerData);
      _markers.removeWhere((marker) => marker.point == markerData.position);
    });
    _saveMarkers(); // Save changes to shared preferences
  }


  //Show Marker Info
  // Show Marker Info with delete option
  void _showMarkerInfo(MarkerData markerData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(markerData.title),
        content: Text(markerData.description),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
          TextButton(
            onPressed: () {
              _deleteMarker(markerData);
              Navigator.pop(context);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }


  //Search Functionality
  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    final url = 'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if(data.isNotEmpty) {
      setState(() {
        _searchResults = data;
      });
    }
    else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  //Move to specific location
  void _moveToLocation(double lat, double lon) {
    LatLng location = LatLng(lat, lon);
    _mapController.move(location, 15.0);
    setState(() {
      _selectedPosition = location;
      _searchResults = [];
      _isSearching = false;
      _searchController.clear();
    });
  }

  // Save markers to shared preferences
  Future<void> _saveMarkers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> markersJson = _markerData.map((marker) => json.encode(marker.toMap())).toList();
    await prefs.setStringList('markers', markersJson);
  }

  // Load saved markers from shared preferences
  Future<void> _loadMarkers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? markersJson = prefs.getStringList('markers');
    if (markersJson != null) {
      setState(() {
        _markerData = markersJson.map((e) => MarkerData.fromMap(json.decode(e))).toList();
        _markers = _markerData.map((data) => Marker(
          point: data.position,
          width: 80,
          height: 80,
          child: GestureDetector(
            onTap: () => _showMarkerInfo(data),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ]
                    ),
                    child: Text(
                      data.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.location_on,
                    color: Colors.redAccent,
                    size: 40,
                  )
                ],
              ),
            ),
          ),
        )).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMarkers(); // Load saved markers when the app starts
    _searchController.addListener(() {
      _searchPlaces(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialZoom: 13.0,
              onTap: (tapPosition, latlng){
                setState(() {
                  _selectedPosition = latlng;
                  _draggedPosition = _selectedPosition;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(markers: _markers),
              if(_isDragging && _draggedPosition != null)
                MarkerLayer(markers: [
                  Marker(
                      point: _draggedPosition!,
                      height: 80,
                      width: 80,
                      child: Icon(Icons.location_on,
                        color: Colors.indigo,
                        size: 40,)
                  ),
                ],
                ),
              if( _myLocation != null)
                MarkerLayer(
                    markers: [
                      Marker(
                          point: _myLocation!,
                          height: 80,
                          width: 80,
                          child: Icon(Icons.location_on,
                            color: Colors.green,
                            size: 40, )
                      ),
                    ] )
            ],
          ),
          //search widget
          Positioned(
              top: 40,
              left: 15,
              right: 15,
              child: Column(
                children: [
                  SizedBox(
                    height: 55,
                    child: // Beautified TextField and Text styling
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search place...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.deepOrangeAccent),
                        suffixIcon: _isSearching
                            ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _isSearching = false;
                              _searchResults = [];
                            });
                          },
                          icon: Icon(Icons.clear, color: Colors.deepOrangeAccent),
                        )
                            : null,
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      onTap: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                    ),

                  ),
                  if(_isSearching && _searchResults.isNotEmpty)
                    Container(
                      color: Colors.white,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (ctx, index) {
                          final place = _searchResults[index];
                          return ListTile(
                            title: Text(
                              place['display"Add Marker"_name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              final lat = double.parse(place['lat']);
                              final lon = double.parse(place['lon']);
                              _moveToLocation(lat, lon);
                            },
                          );
                        },
                      ),
                    )
                ],
              )
          ),
          //Add location button
          _isDragging == false ? Positioned(
              bottom: 20,
              left: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.deepOrangeAccent,
                foregroundColor: Colors.white,
                onPressed: () {
                  setState(() {
                    _isDragging = true;
                  });
                },
                child: Icon(Icons.add_location),
              )
          )
              :
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  _isDragging = false;
                });
              },
              child: Icon(Icons.wrong_location),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepOrangeAccent,
                  onPressed: _showCurrentLocation,
                  child: Icon(Icons.location_searching_rounded),
                ),
                if(_isDragging)
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: FloatingActionButton(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      onPressed: () {
                        if(_draggedPosition != null) {
                          //Adding Marker
                          _showMarkerDialog(context, _draggedPosition!);
                        }
                        setState(() {
                          _isDragging = false;
                          _draggedPosition = null;
                        });
                      },
                      child: Icon(Icons.check),
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
