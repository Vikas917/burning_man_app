import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final Set<int> favoriteEventIds;
  final List<Map<String, dynamic>> events;
  final Function(int eventId) onFavoriteToggle; // Callback for toggling favorites

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
        title: Text('Favorites'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
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
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  event['title'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      event['category'],
                      style: TextStyle(color: Colors.indigo),
                    ),
                    SizedBox(height: 4),
                    Text(
                      event['date'],
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    SizedBox(height: 8),
                    Text(
                      event['description'],
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
                // trailing: IconButton(
                //   icon: Icon(
                //     favoriteEventIds.contains(event['id']) ? Icons.favorite : Icons.favorite_border,
                //     color: favoriteEventIds.contains(event['id']) ? Colors.red : null,
                //   ),
                //   onPressed: () => onFavoriteToggle(event['id']), // Toggle favorite
                // ),
              ),
            );
          },
        ),
      ),
    );
  }
}
