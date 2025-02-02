import 'package:burning_man_app/calender_page.dart';
import 'package:burning_man_app/event_screen.dart';
import 'package:burning_man_app/favorites_screen.dart';
import 'package:burning_man_app/map_screens.dart';
import 'package:burning_man_app/search_event_page.dart';
import 'package:flutter/material.dart';

class TabsEventPage extends StatelessWidget {
  const TabsEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Adjust based on the number of tabs you have
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white,),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage(events: [],)),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.people,color: Colors.white,),
              onPressed: () {
                // Navigate to the People page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarPage(events: [],)),
                );
              },
            ),
          ],

          backgroundColor: Colors.deepOrangeAccent,
          //centerTitle: true,
          title: const Text('Burning Man App'),

          bottom: const TabBar(
            tabs: [
              Tab(text: "Map",),
              Tab(text: 'Events'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MapScreens(),  // Make sure the ArtApiPage is here
            EventsPage(),  // Replace with your actual page widget
            FavoritesPage(favoriteEventIds: Set(), events: [], onFavoriteToggle: (int eventId) {  },),  // Replace with your actual page widget
          ],
        ),
      ),
    );

  }
}
