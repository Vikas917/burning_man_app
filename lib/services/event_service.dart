import '../utils/mock_data.dart';

class EventService {
  Future<List<Map<String, dynamic>>> fetchEvents() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate a network delay
    return mockEvents;
  }
}
