import 'package:latlong2/latlong.dart';

class MarkerData {
  final LatLng position;
  final String title;
  final String description;

  MarkerData({
    required this.position, required this.title, required this.description
  });

// Convert a MarkerData object to a map
  Map<String, dynamic> toMap() {
    return {
      'position_lat': position.latitude,
      'position_lng': position.longitude,
      'title': title,
      'description': description,
    };
  }

  // Create a MarkerData object from a map
  factory MarkerData.fromMap(Map<String, dynamic> map) {
    return MarkerData(
      position: LatLng(map['position_lat'], map['position_lng']),
      title: map['title'],
      description: map['description'],
    );
  }
}

