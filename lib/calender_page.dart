import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key, required List<Map<String, dynamic>> events}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<Map<String, dynamic>>> _groupedEvents = {};
  DateTime _selectedDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Load events from SharedPreferences
  }

  void _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsData = prefs.getStringList('events');
    if (eventsData != null) {
      List<Map<String, dynamic>> loadedEvents = eventsData
          .map((eventJson) => Map<String, dynamic>.from(jsonDecode(eventJson)))
          .toList();
      setState(() {
        _groupEvents(loadedEvents); // Group loaded events
      });
    } else {
      setState(() {
        _groupedEvents = {}; // Default empty map if no events
      });
    }
  }

  void _groupEvents(List<Map<String, dynamic>> events) {
    Map<DateTime, List<Map<String, dynamic>>> groupedEvents = {};
    for (var event in events) {
      try {
        final eventDate = _dateFormat.parse(event['date']);
        final dateKey = DateTime(eventDate.year, eventDate.month, eventDate.day);
        if (groupedEvents[dateKey] == null) {
          groupedEvents[dateKey] = [];
        }
        groupedEvents[dateKey]!.add(event);
      } catch (e) {
        print('Error parsing date: ${event['date']} - $e');
      }
    }
    setState(() {
      _groupedEvents = groupedEvents;
    });
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime date) {
    return _groupedEvents[DateTime(date.year, date.month, date.day)] ?? [];
  }

  void _addEvent(String title, String description, DateTime date) {
    setState(() {
      final newEvent = {
        'title': title,
        'description': description,
        'date': _dateFormat.format(date),
      };
      final dateKey = DateTime(date.year, date.month, date.day);
      if (_groupedEvents[dateKey] == null) {
        _groupedEvents[dateKey] = [];
      }
      _groupedEvents[dateKey]!.add(newEvent);
      _saveEvents(); // Save events to SharedPreferences whenever a new event is added
    });
  }

  void _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> eventsList = [];
    for (var date in _groupedEvents.keys) {
      for (var event in _groupedEvents[date]!) {
        eventsList.add(jsonEncode(event)); // Convert to string before saving
      }
    }
    await prefs.setStringList('events', eventsList); // Save the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Calendar'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDate,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            eventLoader: _getEventsForDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(),
        backgroundColor: Colors.deepOrangeAccent,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventList() {
    final eventsForDay = _getEventsForDay(_selectedDate);

    if (eventsForDay.isEmpty) {
      return Center(
        child: Text(
          'No events for this day!',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      itemCount: eventsForDay.length,
      itemBuilder: (context, index) {
        final event = eventsForDay[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(event['title'], style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(event['description']),
          ),
        );
      },
    );
  }

  void _showAddEventDialog() {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = _titleController.text;
                final description = _descriptionController.text;

                if (title.isNotEmpty && description.isNotEmpty) {
                  _addEvent(title, description, _selectedDate);
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
