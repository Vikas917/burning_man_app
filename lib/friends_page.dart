// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
//
// import 'friend_model.dart'; // For latitude/longitude handling
//
// class FriendsPage extends StatefulWidget {
//   @override
//   _FriendsPageState createState() => _FriendsPageState();
// }
//
// class _FriendsPageState extends State<FriendsPage> {
//   // Sample data for friends
//   final List<Friend> friends = [
//     Friend(
//       name: 'Alice',
//       imageUrl: 'https://via.placeholder.com/150',
//       latitude: 40.7864,
//       longitude: -119.2065,
//       schedule: 'At Art Installation A from 2-4 PM',
//     ),
//     Friend(
//       name: 'Bob',
//       imageUrl: 'https://via.placeholder.com/150',
//       latitude: 40.7870,
//       longitude: -119.2060,
//       schedule: 'At Music Stage B from 3-5 PM',
//     ),
//     // Add more friends here
//   ];
//
//   List<Marker> markers = [];
//
//   @override
//   void initState() {
//     super.initState();
//     // Convert friends' locations into map markers
//     markers = friends.map((friend) {
//       return Marker(
//         width: 80.0,
//         height: 80.0,
//         point: LatLng(friend.latitude, friend.longitude),
//         builder: (context) => GestureDetector(
//           onTap: () {
//             // Show more details about the friend (e.g., schedule)
//             showDialog(
//               context: context,
//               builder: (_) => AlertDialog(
//                 title: Text(friend.name),
//                 content: Text(friend.schedule),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text("Close"),
//                   ),
//                 ],
//               ),
//             );
//           },
//           child: Icon(
//             Icons.location_on,
//             color: Colors.redAccent,
//             size: 40.0,
//           ),
//         ),
//       );
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Friends at Burning Man'),
//       ),
//       body: Column(
//         children: [
//           // Map displaying friends' locations
//           Expanded(
//             child: FlutterMap(
//               options: MapOptions(
//                 initialCenter: LatLng(40.7864, -119.2065), // Initial map center
//                 initialZoom: 15,
//               ),
//               layers: [
//                 TileLayerOptions(
//                   urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                   subdomains: ['a', 'b', 'c'],
//                 ),
//                 MarkerLayerOptions(
//                   markers: markers,
//                 ),
//               ],
//             ),
//           ),
//
//           // List of friends and their schedules
//           Expanded(
//             child: ListView.builder(
//               itemCount: friends.length,
//               itemBuilder: (context, index) {
//                 final friend = friends[index];
//                 return ListTile(
//                   leading: CircleAvatar(
//                     backgroundImage: NetworkImage(friend.imageUrl),
//                   ),
//                   title: Text(friend.name),
//                   subtitle: Text(friend.schedule),
//                   onTap: () {
//                     // Navigate to friend's details (you can expand this)
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
