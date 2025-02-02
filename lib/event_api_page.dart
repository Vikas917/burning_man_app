import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventApiPage extends StatefulWidget {
  @override
  _EventApiPageState createState() => _EventApiPageState();
}

class _EventApiPageState extends State<EventApiPage> {
  List<dynamic> eventItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEventData();
  }

  // Function to fetch event data from the API
  Future<void> fetchEventData() async {
    final url = 'https://api.burningman.org/api/v1/event?year=2015';
    final uri = Uri.parse(url);

    // Credentials: API Key
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
          eventItems = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load event data. Status code: ${response.statusCode}');
        throw Exception('Failed to load event data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      // appBar: AppBar(
      //   // backgroundColor: Colors.deepOrangeAccent,
      //   // centerTitle: true,
      //   //title: Text('Burning Man Events 2015'),
      // ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: eventItems.length,
        itemBuilder: (context, index) {
          final event = eventItems[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'), // Starts from 1
            ),
            title: Text(event['title'] ?? 'No Title',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            subtitle: Text(event['event_type']['label'] ?? 'No Event Type'),
            onTap: () {
              // Navigate to a new screen to show event details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailPage(event: event),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchEventData,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class EventDetailPage extends StatelessWidget {
  final dynamic event;

  EventDetailPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        title: Text(event['title'] ?? 'No Title'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // Wrap the Column with SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),

              // Event Title with bold styling
              Text(
                event['title'] ?? 'No Title',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Description with bold label
              Row(
                children: [
                  Text(
                    'Description: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // Bold label
                  ),
                  Expanded(
                    child: Text(
                      event['description'] ?? 'No Description',
                      style: TextStyle(fontSize: 16),
                      softWrap: true,  // Ensure text wraps if it's too long
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Event Type with bold label
              Row(
                children: [
                  Text(
                    'Event Type: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // Bold label
                  ),
                  Text(
                    event['event_type']['label'] ?? 'Unknown',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Time with bold label
              Row(
                children: [
                  Text(
                    'Time: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // Bold label
                  ),
                  Text(
                    event['occurrence_set'][0]['start_time'] ?? 'No Time',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Contact with bold label
              if (event['contact'] != null)
                Row(
                  children: [
                    Text(
                      'Contact: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // Bold label
                    ),
                    Text(
                      event['contact'] ?? 'No Contact',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              SizedBox(height: 8),

              // Other Location with bold label
              if (event['other_location'] != null)
                Row(
                  children: [
                    Text(
                      'Other Location: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // Bold label
                    ),
                    Text(
                      event['other_location'] ?? 'No Other Location',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
            ],
          ),

        ),
      ),
    );
  }
}
/*
// Distance & Time Info
Positioned(
  bottom: 20,
  left: 20,
  right: 20,
  child: Card(
    color: Colors.white,
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions, color: Colors.deepOrange, size: 28),
              SizedBox(width: 8),
              Text(
                'Navigation Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(),

          // Car travel
          Row(
            children: [
              Icon(Icons.directions_car, color: Colors.blue, size: 28),
              SizedBox(width: 10),
              Text(
                'Car: 8 min (4.5 km)',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 8),

          // Bus travel
          Row(
            children: [
              Icon(Icons.directions_bus, color: Colors.red, size: 28),
              SizedBox(width: 10),
              Text(
                'Bus: 15 min (4.5 km)',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 8),

          // Walking travel
          Row(
            children: [
              Icon(Icons.directions_walk, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text(
                'Walking: 45 min (4.5 km)',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
),

 */