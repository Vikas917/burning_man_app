import 'package:burning_man_app/search_event_page.dart';
import 'package:flutter/material.dart';
import 'calender_page.dart';
import 'event_details_page.dart';
import 'favorites_screen.dart';
import 'map_screens.dart'; // Import for FavoritesPage

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Map<String, dynamic>> _events = [
    {'id': 1, 'title': 'A Musical Show for Everything!', 'description': 'Join us for an unforgettable evening of music as talented performers bring timeless tunes to life. Experience melodies from forgotten eras in this nostalgic musical performance. The show will take place on Saturday, February 15, 2025, from 7:30 PM to 10:00 PM at the Grand Hall, Downtown Venue.', 'date': 'Sat 2/15/2025 7:30 PM - Sat 2/15/2025 10:00 PM', 'category': 'Live Music'},
    {'id': 2, 'title': 'A Triple Wedding Triumphant Wonder!', 'description': 'Celebrate love in all its forms as three couples unite in a spectacular ceremony. With vows exchanged and joyous celebrations, this is an event not to be missed. The triple wedding celebration will take place at Sunset Gardens, Los Angeles on Friday, February 21, 2025, from 6:00 PM to 8:30 PM.', 'date': 'Fri 2/21/2025 6:00 PM - Fri 2/21/2025 8:30 PM', 'category': 'Ritual/Ceremony'},
    {'id': 3, 'title': 'Upraorious Flame Orchestra', 'description': 'Prepare to be mesmerized by an explosive fire performance that lights up the night sky. Join fire spinners and dancers as they create a captivating symphony of light and heat. This unforgettable fire performance will take place at the Phoenix Arena in Nevada on Friday, March 7, 2025, from 8:00 PM to midnight.', 'date': 'Fri 3/7/2025 8:00 PM - Sat 3/8/2025 12:00 AM', 'category': 'Fire/Spectacle'},
    {'id': 4, 'title': 'Play With A Giant Toy From The Past', 'description': 'Rediscover your childhood joy with a giant toy experience. This interactive event will bring a toy from the past to life in an immersive, fun-filled session. The event will take place at Memory Lane Park, Austin, Texas on Saturday, March 15, 2025, from 3:00 PM to 6:00 PM.', 'date': 'Sat 3/15/2025 3:00 PM - Sat 3/15/2025 6:00 PM', 'category': 'Games'},
    {'id': 5, 'title': 'Moonlit Dance Party', 'description': 'Dance under the stars to the most enchanting beats as you join us at the Moonlit Dance Party. A magical evening that blends music, light, and community. Come and experience the joy of dancing under a celestial canopy at Crescent Park, San Francisco, on Saturday, April 5, 2025, from 8:00 PM to midnight.', 'date': 'Sat 4/5/2025 8:00 PM - Sun 4/6/2025 12:00 AM', 'category': 'Dance'},
    {'id': 6, 'title': 'Solar Flare Sculpture', 'description': 'Marvel at the beauty of light and art combined in the Solar Flare Sculpture exhibition. This installation combines elements of light, shadow, and shape in a powerful visual experience. This awe-inspiring artwork will be on display at The Glow Gallery, New York, from April 12 to April 13, 2025.', 'date': 'Sat 4/12/2025 10:00 AM - Sun 4/13/2025 6:00 PM', 'category': 'Art/Installation'},
    {'id': 7, 'title': 'Silent Meditation', 'description': 'Join us for a peaceful meditation session that offers a serene escape from the chaos of everyday life. Disconnect and reconnect with your inner peace in this guided silent meditation event at the Tranquil Garden, Denver, Colorado on Thursday, April 17, 2025, from 6:00 AM to 7:00 AM.', 'date': 'Thu 4/17/2025 6:00 AM - Thu 4/17/2025 7:00 AM', 'category': 'Meditation'},
    {'id': 8, 'title': 'Neon Glow Yoga', 'description': 'Stretch, flow, and meditate under vibrant neon lights at Neon Glow Yoga. This unique yoga session combines wellness with a creative, glowing atmosphere. Join us for this vibrant event at Yoga Studios in Miami on Friday, May 2, 2025, from 7:00 AM to 8:00 AM.', 'date': 'Fri 5/2/2025 7:00 AM - Fri 5/2/2025 8:00 AM', 'category': 'Wellness'},
    {'id': 9, 'title': 'Desert Art Tour', 'description': 'Experience the captivating artwork scattered throughout the desert landscape. Explore sculptures, paintings, and installations that engage with nature in unique ways. This two-hour art tour will be held at Desert Ridge, Arizona on Saturday, May 10, 2025, from 10:00 AM to 12:00 PM.', 'date': 'Sat 5/10/2025 10:00 AM - Sat 5/10/2025 12:00 PM', 'category': 'Art Tour'},
    {'id': 10, 'title': 'Burning Art: Fireworks Show', 'description': 'The grand finale of the festival! Watch as the sky bursts into a riot of color with a breathtaking fireworks display. The Burning Art Fireworks Show will take place at Blaze Stadium, Los Angeles on Saturday, May 17, 2025, from 9:00 PM to 10:00 PM.', 'date': 'Sat 5/17/2025 9:00 PM - Sat 5/17/2025 10:00 PM', 'category': 'Fireworks'},
    {'id': 11, 'title': 'Ethereal Dance of Lights', 'description': 'Witness a spellbinding dance of lights that will take you on a journey through a cosmic wonderland. The performance blends intricate choreography with mesmerizing lighting effects. Don’t miss this event at the Celestial Theater, Chicago on Sunday, February 23, 2025, from 7:30 PM to 9:00 PM.', 'date': 'Sun 2/23/2025 7:30 PM - Sun 2/23/2025 9:00 PM', 'category': 'Light Show'},
    {'id': 12, 'title': 'Soundwaves in the Sand', 'description': 'Explore the acoustic wonders of the desert as soundwaves reverberate through the dunes. A truly experimental experience that blends nature and music. Join us at the Desert Echoes, Nevada on Friday, March 21, 2025, from 8:00 PM to midnight.', 'date': 'Fri 3/21/2025 8:00 PM - Sat 3/22/2025 12:00 AM', 'category': 'Experimental Music'},
    {'id': 13, 'title': 'Cosmic Circus', 'description': 'A carnival like no other. A night of bizarre performers, acrobats, and fantastical creatures that will make you question reality. This will be held at the Cosmic Circus Arena, Portland, Oregon on Saturday, April 26, 2025, from 7:00 PM to 10:00 PM.', 'date': 'Sat 4/26/2025 7:00 PM - Sat 4/26/2025 10:00 PM', 'category': 'Circus'},
  ];

  Set<int> _favoriteEventIds = Set<int>();
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(events: _events), // Navigate to SearchPage
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarPage(events: _events),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        child: ListView.builder(
          itemCount: _events.length,
          itemBuilder: (context, index) {
            final event = _events[index];
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
                      style: TextStyle(fontSize: 14, color: Colors.redAccent),
                    ),
                    SizedBox(height: 8),
                    Text(
                      event['description'].length > 100 ? event['description'].substring(0, 80) + '...' : event['description'],
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
                // trailing: IconButton(
                //   icon: Icon(
                //     _favoriteEventIds.contains(event['id']) ? Icons.favorite : Icons.favorite_border,
                //     color: _favoriteEventIds.contains(event['id']) ? Colors.red : null,
                //   ),
                //   onPressed: () {
                //     setState(() {
                //       if (_favoriteEventIds.contains(event['id'])) {
                //         _favoriteEventIds.remove(event['id']);
                //       } else {
                //         _favoriteEventIds.add(event['id']);
                //       }
                //     });
                //   },
                // ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailPage(
                        event: event,
                        favoriteEventIds: _favoriteEventIds, // Pass favorite event IDs
                        onFavoriteToggle: (eventId) { // Pass onFavoriteToggle function
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritesPage(
                  favoriteEventIds: _favoriteEventIds,
                  events: _events,
                  onFavoriteToggle: (int eventId) {  },),
              ),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapScreens(),
              ),
            );
          }
        },
      ),
    );
  }
}
