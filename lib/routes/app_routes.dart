import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/camp_detail_screen.dart';
import '../screens/event_detail_screen.dart';
import '../screens/map_screen.dart';

class AppRoutes {
  static final routes = {
    '/camp': (context) => CampDetailScreen(campName: '', description: '', location: '',),
    '/event': (context) => EventDetailScreen(eventName: '', details: '', time: '',),
    '/map': (context) => MapScreen(events: [],),
  };
}
