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
        title: Text(widget.event['title']),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.event['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.event['category'],
              style: TextStyle(fontSize: 18, color: Colors.indigo),
            ),
            SizedBox(height: 10),
            Text(
              widget.event['date'],
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            SizedBox(height: 20),
            Text(
              widget.event['description'],
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFavorite,
        child: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite ? Colors.red : null,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
