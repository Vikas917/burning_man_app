import 'package:flutter/material.dart';
import 'event_details_page.dart'; // Import EventDetailPage

class SearchPage extends StatefulWidget {
  final List<Map<String, dynamic>> events; // Pass events list from EventsPage

  const SearchPage({Key? key, required this.events}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = ''; // Stores the search query
  Set<int> _favoriteEventIds = {}; // Store favorite event IDs

  @override
  Widget build(BuildContext context) {
    // Filter events based on the search query
    List<Map<String, dynamic>> filteredEvents = widget.events.where((event) {
      return event['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event['category'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event['description'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Events'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar with rounded border and placeholder text
            TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search for events...', // Placeholder text
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Rounded border
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
            SizedBox(height: 16),
            // Show filtered events only if the search query is not empty
            if (_searchQuery.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                      child: ListTile(
                        title: Text(event['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(event['date']),
                        onTap: () {
                          // Navigate to EventDetailPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailPage(
                                event: event,
                                favoriteEventIds: _favoriteEventIds,
                                onFavoriteToggle: (eventId) {
                                  setState(() {
                                    if (_favoriteEventIds.contains(eventId)) {
                                      _favoriteEventIds.remove(eventId);
                                    } else {
                                      _favoriteEventIds.add(eventId);
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
