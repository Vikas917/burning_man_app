import '../utils/mock_data.dart';

class CampService {
  Future<List<Map<String, dynamic>>> fetchCamps() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate a network delay
    return mockCamps;
  }
}
