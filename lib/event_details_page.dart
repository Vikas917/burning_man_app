import 'package:flutter/material.dart';

class EventDetailPage extends StatefulWidget {
  final Map<String, dynamic> event;
  final Set<int> favoriteEventIds;
  final Function(int) onFavoriteToggle;

  const EventDetailPage({
    Key? key,
    required this.event,
    required this.favoriteEventIds,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.favoriteEventIds.contains(widget.event['id']);
  }

  void _toggleFavorite() {
    widget.onFavoriteToggle(widget.event['id']);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event Details', // Title added here
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Add share functionality if needed
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event title
            // Centered Event title
            Center(
              child: Text(
                widget.event['title'],
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Centered Category Section
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  widget.event['category'],
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Event date
            Text(
              widget.event['date'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.redAccent,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),
            // Event description
            Text(
              widget.event['description'],
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 40),
            // Final message
            Align(
              alignment: Alignment.center,
              child: Text(
                'Have fun and enjoy the event!',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.purpleAccent,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFavorite,
        child: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite ? Colors.white : Colors.deepOrangeAccent,
        ),
        backgroundColor: _isFavorite ? Colors.red : Colors.white,
        elevation: 6.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
