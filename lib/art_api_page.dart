import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';

class ArtApiPage extends StatefulWidget {
  @override
  _ArtApiPageState createState() => _ArtApiPageState();
}

class _ArtApiPageState extends State<ArtApiPage> {
  List<dynamic> artItems = [];
  bool isLoading = true;

  // Variables to store walking, cycling, and car times
  Map<String, String> walkingTimes = {};
  Map<String, String> cyclingTimes = {};
  Map<String, String> carTimes = {};  // Add car times

  @override
  void initState() {
    super.initState();
    fetchArtData();
  }

  Future<void> fetchArtData() async {
    final url = 'https://api.burningman.org/api/v1/art?year=2023';
    final uri = Uri.parse(url);
    final encodedCredentials = base64Encode(utf8.encode('8b036b6e8f668d5267a493568078d8d1:'));

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Basic $encodedCredentials',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          artItems = json.decode(response.body);
          isLoading = false;
        });
        _fetchTimes();
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load art data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Error: $e');
    }
  }

  // Fetch walking, cycling, and car times for each artwork
  Future<void> _fetchTimes() async {
    for (var art in artItems) {
      final latitude = art['location']?['gps_latitude'];
      final longitude = art['location']?['gps_longitude'];

      if (latitude != null && longitude != null) {
        final Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        final String urlCar = "https://router.project-osrm.org/route/v1/driving/${position.longitude},${position.latitude};${longitude},${latitude}?overview=full&geometries=geojson";
        final String urlCycle = "https://router.project-osrm.org/route/v1/cycling/${position.longitude},${position.latitude};${longitude},${latitude}?overview=full&geometries=geojson";
        final String urlWalk = "https://router.project-osrm.org/route/v1/walking/${position.longitude},${position.latitude};${longitude},${latitude}?overview=full&geometries=geojson";  // Walking route

        final responseCar = await http.get(Uri.parse(urlCar));
        final responseCycle = await http.get(Uri.parse(urlCycle));
        final responseWalk = await http.get(Uri.parse(urlWalk)); // Get walking response

        if (responseCar.statusCode == 200 && responseCycle.statusCode == 200 && responseWalk.statusCode == 200) {
          var dataCar = json.decode(responseCar.body);
          var dataCycle = json.decode(responseCycle.body);
          var dataWalk = json.decode(responseWalk.body);  // Walking data

          var routeCar = dataCar["routes"][0];
          var routeCycle = dataCycle["routes"][0];
          var routeWalk = dataWalk["routes"][0];  // Walking route

          setState(() {
            walkingTimes[art['name']] = "${(routeWalk["duration"] / 5).toStringAsFixed(0)} min";
            cyclingTimes[art['name']] = "${(routeCycle["duration"] / 15).toStringAsFixed(0)} min";
            carTimes[art['name']] = "${(routeCar["duration"] / 60).toStringAsFixed(0)} min";  // Convert to minutes
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: artItems.length,
        itemBuilder: (context, index) {
          final art = artItems[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: art['images'] != null && art['images'].isNotEmpty
                  ? Image.network(art['images'][0]['thumbnail_url'] ?? '', width: 50, height: 50, fit: BoxFit.cover)
                  : Icon(Icons.image, size: 50),
            ),
            title: Text(
              art['name'] ?? 'No Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(art['artist'] ?? 'No Artist'),
                // Display walking, cycling, and car times side by side with their icons
                if (walkingTimes.containsKey(art['name']) && cyclingTimes.containsKey(art['name']) && carTimes.containsKey(art['name']))
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Allows horizontal scrolling
                    child: Row(
                      children: [
                        Icon(Icons.directions_walk, color: Colors.green, size: 16),
                        //SizedBox(width: 5),
                        Text(
                          walkingTimes[art['name']] ?? '',
                          style: TextStyle(fontSize: 14, color: Colors.green),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.directions_bike, color: Colors.purple, size: 16),
                        SizedBox(width: 5),
                        Text(
                          cyclingTimes[art['name']] ?? '',
                          style: TextStyle(fontSize: 14, color: Colors.purple),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.directions_car, color: Colors.blue, size: 16),
                        SizedBox(width: 5),
                        Text(
                          carTimes[art['name']] ?? '',
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),

              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArtDetailPage(art: art),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchArtData,
        child: Icon(Icons.refresh),
      ),
    );
  }
}



class ArtDetailPage extends StatelessWidget {
  final dynamic art;

  ArtDetailPage({required this.art});

  @override
  Widget build(BuildContext context) {
    double? latitude = art['location']?['gps_latitude'] != null
        ? double.tryParse(art['location']['gps_latitude'].toString())
        : null;
    double? longitude = art['location']?['gps_longitude'] != null
        ? double.tryParse(art['location']['gps_longitude'].toString())
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        title: Text(art['name'] ?? 'No Name'),
      ),
      backgroundColor: Colors.orange[50],
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Art Image or Icon if no image available
              art['images'] != null && art['images'].isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  art['images'][0]['thumbnail_url'] ?? '',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              )
                  : Icon(Icons.image, size: 100, color: Colors.grey),

              SizedBox(height: 10),

              // Art Name
              Text(
                art['name'] ?? 'No Name',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Artist Row
              Row(
                children: [
                  Icon(Icons.person, size: 24, color: Colors.deepOrangeAccent),
                  SizedBox(width: 8),
                  Text(
                    'Artist: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      art['artist'] ?? 'Unknown',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Hometown Row
              Row(
                children: [
                  Icon(Icons.location_city, size: 24, color: Colors.deepOrangeAccent),
                  SizedBox(width: 8),
                  Text(
                    'Hometown: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      art['hometown'] ?? 'Unknown',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // location Row
              Row(
                children: [
                  Icon(Icons.place, size: 24, color: Colors.deepOrangeAccent),
                  SizedBox(width: 8),
                  Text(
                    'Location: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    art['location']?['string'] ?? 'Unknown',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // GPS Coordinates
              if (latitude != null && longitude != null)
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.gps_fixed, size: 24, color: Colors.deepOrangeAccent),
                        SizedBox(width: 8),
                        Text(
                          'GPS Coordinates: ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            '$latitude, $longitude',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Custom Styled Elevated Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArtMapPage(
                              latitude: latitude,
                              longitude: longitude,
                              artName: art['name'] ?? 'No Name',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepOrangeAccent, // Text color
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding around the text
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                        elevation: 5, // Shadow effect
                      ),
                      child: Text('View on Map', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),

              SizedBox(height: 8),



              // Location Row

              // Donation Link (if available)
              if (art['donation_link'] != null)
                Row(
                  children: [
                    Icon(Icons.monetization_on, size: 24, color: Colors.deepOrangeAccent),
                    SizedBox(width: 8),
                    Text(
                      'Donation Link: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        art['donation_link'] ?? 'No Donation Link',
                        style: TextStyle(fontSize: 16,color: Colors.blue,decoration: TextDecoration.underline),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 8),

              // Website Row (if available)
              if (art['url'] != null)
                Row(
                  children: [
                    Icon(Icons.link, size: 24, color: Colors.deepOrangeAccent),
                    SizedBox(width: 8),
                    Text(
                      'Website: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        art['url'] ?? 'No Website',
                        style: TextStyle(fontSize: 16,color: Colors.blue,decoration: TextDecoration.underline),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 8),

              // Contact Email Row (if available)
              if (art['contact_email'] != null)
                Row(
                  children: [
                    Icon(Icons.email, size: 24, color: Colors.deepOrangeAccent),
                    SizedBox(width: 8),
                    Text(
                      'Contact Email: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        art['contact_email'] ?? 'No Contact Email',
                        style: TextStyle(fontSize: 16,color: Colors.blue,decoration: TextDecoration.underline),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 8),

              //Description Row
              Row(
                children: [
                  Icon(Icons.description, size: 24, color: Colors.deepOrangeAccent),
                  SizedBox(width: 8),
                  Text(
                    'Description: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      art['description'] ?? 'No Description',
                      style: TextStyle(fontSize: 16),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
            ],

          ),
        ),
      ),
    );
  }
}



class ArtMapPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String artName;

  ArtMapPage({required this.latitude, required this.longitude, required this.artName});

  @override
  _ArtMapPageState createState() => _ArtMapPageState();
}

class _ArtMapPageState extends State<ArtMapPage> {
  LatLng? _userLocation;
  List<LatLng> _routePoints = [];
  String _distance = "";
  String _timeCar = "";
  String _timeBus = "";
  String _timeWalk = "";
  String _timeCycle = "";  // New variable for cycling time

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // Function to round coordinates for precision issues
  double roundCoordinate(double coord) {
    return double.parse(coord.toStringAsFixed(6));  // Limit precision to 6 decimal places
  }

  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _userLocation = LatLng(roundCoordinate(position.latitude), roundCoordinate(position.longitude));
    });
    _fetchRouteAndTime();
  }

  Future<void> _fetchRouteAndTime() async {
    if (_userLocation == null) return;

    final String urlCar = "https://router.project-osrm.org/route/v1/driving/${_userLocation!.longitude},${_userLocation!.latitude};${widget.longitude},${widget.latitude}?overview=full&geometries=geojson";
    final String urlCycle = "https://router.project-osrm.org/route/v1/cycling/${_userLocation!.longitude},${_userLocation!.latitude};${widget.longitude},${widget.latitude}?overview=full&geometries=geojson"; // Cycling route URL

    final responseCar = await http.get(Uri.parse(urlCar));
    final responseCycle = await http.get(Uri.parse(urlCycle));  // Fetch cycling route

    if (responseCar.statusCode == 200 && responseCycle.statusCode == 200) {
      var dataCar = json.decode(responseCar.body);
      var dataCycle = json.decode(responseCycle.body);  // Parse cycling data
      var routeCar = dataCar["routes"][0];
      var routeCycle = dataCycle["routes"][0];  // Get the cycling route

      var coordinatesCar = routeCar["geometry"]["coordinates"];
      var coordinatesCycle = routeCycle["geometry"]["coordinates"];  // Get cycling coordinates

      setState(() {
        _routePoints = coordinatesCar.map<LatLng>((coord) => LatLng(coord[1], coord[0])).toList();
        _distance = "${(routeCar["distance"] / 1000).toStringAsFixed(2)} km";
        _timeCar = "${(routeCar["duration"] / 60).toStringAsFixed(0)} min by Car";
        _timeBus = "${(routeCar["duration"] / 45).toStringAsFixed(0)} min by Bus";
        _timeWalk = "${(routeCar["duration"] / 5).toStringAsFixed(0)} min Walking";
        _timeCycle = "${(routeCycle["duration"] / 15).toStringAsFixed(0)} min by Bicycle";  // Set cycling time
      });
    } else {
      // Handle error if the response is not successful
      print("Error: Unable to fetch routes.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("Art Location"),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _userLocation ?? LatLng(widget.latitude, widget.longitude),
              initialZoom: 15.0,  // Set zoom level higher for better view
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    color: Colors.blue,
                    strokeWidth: 4.0,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  if (_userLocation != null)
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: _userLocation!,
                      child: Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                    ),
                  Marker(
                    width: 120.0, // Increased width to accommodate longer names
                    height: 100.0, // Ensured enough space for both name and marker
                    point: LatLng(widget.latitude, widget.longitude),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible( // Ensures text adjusts dynamically
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            constraints: BoxConstraints(maxWidth: 100), // Prevents overflow
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2)],
                            ),
                            child: Text(
                              widget.artName,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1, // Prevents name from overflowing
                            ),
                          ),
                        ),
                        SizedBox(height: 4), // Adds spacing between text and marker
                        Icon(Icons.location_pin, color: Colors.red, size: 40),
                      ],
                    ),
                  ),
                ],
              ),



            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Distance: $_distance",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      _buildTimeCard(_timeCar, Icons.directions_car, Colors.blue),
                      _buildTimeCard(_timeBus, Icons.directions_bus, Colors.green),
                      _buildTimeCard(_timeWalk, Icons.directions_walk, Colors.orange),
                      _buildTimeCard(_timeCycle, Icons.directions_bike, Colors.purple),  // Cycling card
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 10),
          Expanded(child: Text(time, style: TextStyle(fontSize: 14, color: Colors.black54))),
        ],
      ),
    );
  }
}




