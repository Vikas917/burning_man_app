import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final Set<int> favoriteEventIds;
  final List<Map<String, dynamic>> events;
  final Function(int eventId) onFavoriteToggle;

  const FavoritesPage({
    Key? key,
    required this.favoriteEventIds,
    required this.events,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteEvents = events.where((event) => favoriteEventIds.contains(event['id'])).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 4.0,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.search, color: Colors.white),
          //   onPressed: () {
          //     // Add search functionality if needed
          //   },
          // ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: favoriteEvents.isEmpty
            ? Center(
          child: Text(
            'No favorites yet!',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        )
            : ListView.builder(
          itemCount: favoriteEvents.length,
          itemBuilder: (context, index) {
            final event = favoriteEvents[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              shadowColor: Colors.grey.withOpacity(0.5),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  event['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6),
                    Text(
                      event['category'],
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      event['date'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.redAccent,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      event['description'],
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
                
                trailing: IconButton(
                  icon: Icon(
                    favoriteEventIds.contains(event['id'])
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: favoriteEventIds.contains(event['id'])
                        ? Colors.red
                        : Colors.grey,
                  ),
                  onPressed: () {
                    // Toggle favorite status
                    onFavoriteToggle(event['id']);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
