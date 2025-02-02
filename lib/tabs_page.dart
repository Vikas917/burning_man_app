import 'package:burning_man_app/camp_api_page.dart';
import 'package:burning_man_app/search_event_page.dart';
import 'package:burning_man_app/user_api_page.dart';
import 'package:flutter/material.dart';
import 'package:burning_man_app/art_api_page.dart';

import 'event_api_page.dart'; // Import the ArtApiPage
// import other pages as needed


class TabsPage extends StatelessWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: const Text(
            'BurnTech App',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage(events: [])),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.people, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserApiPage()),
                );
              },
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white, // Active tab text color
            unselectedLabelColor: Colors.white70, // Inactive tab text color
            indicatorColor: Colors.white, // Indicator color
            indicatorWeight: 3.0, // Thickness of the tab indicator
            tabs: [
              Tab(text: "🎨 Art"),
              Tab(text: "🏕 Camps"),
              Tab(text: "📅 Events"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ArtApiPage(),
            CampApiPage(),
            EventApiPage(),
          ],
        ),
      ),
    );
  }
}


// class CampsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Replace this with actual camps data
//     String campsData = "Camps Data: List of Camps at Burning Man";
//
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(campsData),  // Displaying the camps data
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => UserApiPage()),
//               );
//             },
//             child: Text('Go to User API Page'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class EventApiPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Replace this with actual event data
//     String eventData = "Event Data: The main events of Burning Man";
//
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(eventData),  // Displaying the event data
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => UserApiPage()),
//               );
//             },
//             child: Text('Go to User API Page'),
//           ),
//         ],
//       ),
//     );
//   }
// }



// class EventApiPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Replace this with actual event data
//     String eventData = "Event Data: The main events of Burning Man";
//
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(eventData),  // Displaying the event data
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => UserApiPage()),
//               );
//             },
//             child: Text('Go to User API Page'),
//           ),
//         ],
//       ),
//     );
//   }
// }







/*
import 'package:burning_man_app/user_api_page.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainPage(); // Navigating to the MainPage widget
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Dummy data for each tab
  final List<Map<String, String>> _art = [
    {'title': 'Solar Flare Sculpture', 'description': 'The Solar Flare Sculpture combines the power of light and art in a spectacular fusion of design and energy. Standing tall in the desert, the sculpture mimics the sun’s energy, radiating warmth and brilliance. It transforms daylight into a stunning visual masterpiece as light bends and shifts, creating mesmerizing patterns. As the sun sets, the sculpture glows, casting dynamic reflections that capture the essence of both the natural and artistic worlds, making it a powerful symbol of energy and vitality.'},
    {'title': 'Desert Art Tour', 'description': 'Take a journey through the heart of the desert, where the beauty of the landscape and innovative art installations come together. The Desert Art Tour leads you to a series of immersive artworks that engage your senses and imagination. With each installation, you’ll witness how the desert environment influences the creative process, and how artists interpret the land, sky, and culture. From sculptures that move with the wind to interactive pieces that respond to touch, this tour offers a unique experience blending art and nature.'},
    {'title': 'The Burning Tree', 'description': 'The Burning Tree is an awe-inspiring sculpture that symbolizes transformation and renewal. Made of towering wooden branches, the sculpture is set ablaze, creating a mesmerizing visual of fire and light. It stands as a powerful representation of life, death, and rebirth. As the flames rise, they illuminate the desert sky, providing an unforgettable spectacle that captures the raw energy of nature. The Burning Tree connects participants to the cycle of life, offering a reflective experience as the fire burns and transforms the installation in real-time.'},
    {'title': 'Flame Dancer', 'description': 'The Flame Dancer performance is a thrilling spectacle where fire meets movement in an elegant and powerful display. Watch as skilled performers use fire as an extension of their body, spinning, twirling, and creating beautiful shapes with the flames. Set against the desert backdrop at sunset, the performance adds an enchanting glow to the evening. The graceful movements of the dancers, paired with the crackling fire, create a stunning visual experience. This is an art form that requires strength, precision, and a deep connection to the element of fire.'},
    {'title': 'Light Mirage', 'description': 'Light Mirage is a stunning installation that captivates viewers with its radiant glow. As the desert night falls, the artwork comes to life, using light to create the illusion of a shimmering oasis in the otherwise barren landscape. The colors of the installation shift and change, forming patterns that dance and flicker in the darkness. This mesmerizing visual experience draws attention to the transformative power of light and its ability to alter perception. The artwork challenges viewers to reconsider the desert’s emptiness and transforms it into a place of wonder.'},
    {'title': 'Desert Echoes', 'description': 'Desert Echoes is an interactive sound art installation that invites the desert wind to create music. Using specially designed sculptures, the wind plays melodies that are unique to each moment, turning the arid landscape into a live symphony. As the wind interacts with the structures, it creates beautiful, organic soundscapes that echo through the desert. The installation invites you to experience the connection between nature and art, as the desert’s sounds merge with human creativity. Desert Echoes becomes a meditation on the passage of time and the beauty of impermanence.'},
    {'title': 'Ethereal Vision', 'description': 'Ethereal Vision is a reflective art piece that encourages introspection and self-awareness. The installation is designed to engage viewers on an emotional level, with shifting patterns and forms that evoke different feelings and thoughts. The artwork invites you to explore your own inner world, offering new perspectives with every glance. As you move around the installation, the piece changes, revealing new layers and dimensions. This interactive experience challenges you to reflect on the transient nature of life and engage with art in a way that is deeply personal and transformative.'},
    {'title': 'Interactive Art Installation', 'description': 'The Interactive Art Installation blurs the lines between artist and audience, inviting participants to engage with the piece physically, emotionally, and intellectually. The artwork responds to touch, movement, and sound, creating a dynamic and evolving experience. As you interact with the installation, your actions shape its form, demonstrating the power of human participation in art. This immersive experience encourages creativity and exploration, allowing you to become part of the art itself. It challenges the traditional notion of passive viewing, offering a participatory approach to artistic expression.'},
    {'title': 'Metal Shadows', 'description': 'Metal Shadows is a stunning collection of sculptures that cast dramatic, ever-changing shadows in the desert night. The intricate metal designs create complex silhouettes on the desert floor, interacting with light and the movement of viewers. The artwork explores the themes of presence and absence, light and dark, by using the interplay of metal and shadow. The installation invites you to move around the sculptures and witness the constantly shifting shapes, creating a dynamic visual experience that changes with every perspective. Metal Shadows captivates the audience with its bold contrasts and haunting beauty.'},
    {'title': 'Floating Sculpture', 'description': 'The Floating Sculpture is a breathtaking piece of art that seems to defy the laws of physics. Suspended in mid-air, the sculpture appears to hover effortlessly, creating an illusion of weightlessness. Its delicate design contrasts with the harsh desert environment, offering a surreal and thought-provoking experience. As you approach, the artwork seems to shift and change shape, offering new perspectives and angles. The Floating Sculpture challenges the viewer’s understanding of space and gravity, making it a captivating addition to any art installation in the desert landscape.'},
  ];

  final List<Map<String, String>> _camps = [
    {'title': 'Adventure Camp', 'description': 'Adventure Camp offers the ultimate outdoor thrill-seeker experience in the desert. From rock climbing to zip-lining, this camp immerses participants in exhilarating activities surrounded by breathtaking desert views. Whether you’re scaling cliffs, navigating rugged terrain, or testing your limits with extreme sports, Adventure Camp is designed to provide adrenaline-pumping experiences for adventurers of all levels. With expert instructors guiding you, you’ll learn essential survival skills and outdoor techniques while enjoying the vast beauty of the desert. Get ready for an unforgettable adventure in one of the most remote environments on earth.'},
    {'title': 'Yoga Camp', 'description': 'Yoga Camp offers a serene retreat in the heart of the desert where you can disconnect and rejuvenate your mind, body, and soul. Under the guidance of experienced instructors, you’ll explore various yoga practices, from gentle stretching to more advanced poses, designed to relax and strengthen your body. The peaceful desert setting, with its quiet mornings and breathtaking sunsets, provides the perfect environment to deepen your practice. Whether you’re a beginner or an experienced yogi, Yoga Camp offers a transformative experience that will leave you feeling balanced and at peace.'},
    {'title': 'Survival Skills Camp', 'description': 'Survival Skills Camp is your gateway to mastering essential desert survival techniques. Whether you’re navigating the harsh desert terrain, building shelters, or learning how to find water, this camp provides the skills necessary to survive in the wilderness. Expert survival instructors guide you through hands-on activities and real-life scenarios, ensuring you gain the confidence and knowledge to handle emergencies. From fire-starting to map reading, you’ll learn practical techniques that can be used in any challenging outdoor environment, all while being immersed in the desert’s unique beauty and challenges.'},
    {'title': 'Fire Breathers Camp', 'description': 'Fire Breathers Camp is a unique opportunity to learn the ancient and fascinating art of fire breathing. Under the expert guidance of trained professionals, you’ll gain the skills necessary to safely handle fire and perform captivating fire-breathing stunts. The camp provides a combination of theoretical knowledge and hands-on experience, teaching you fire safety, technique, and performance skills. This exciting and challenging camp is ideal for anyone looking to add a fiery flair to their artistic expression. Join us for an unforgettable experience where you’ll become a master of fire and performance.'},
    {'title': 'Circus Camp', 'description': 'Circus Camp offers a fun and dynamic experience for all ages, whether you’re looking to learn new circus arts or hone your existing skills. From juggling and acrobatics to clowning and aerial silks, this camp provides instruction in a wide variety of circus disciplines. You’ll be guided by professional circus artists who will help you develop your technique, creativity, and performance skills. Whether you’re interested in performing for others or just want to try something new, Circus Camp offers a supportive and exciting environment to explore your talents.'},
    {'title': 'Artistic Expression Camp', 'description': 'Artistic Expression Camp is a space where creativity knows no boundaries. Designed for individuals of all skill levels, this camp provides a supportive environment for exploring various artistic forms such as painting, sculpture, photography, and mixed media. Led by professional artists, participants are encouraged to tap into their innermost creativity and express themselves freely. The camp fosters a sense of community, collaboration, and personal growth. Whether you’re a seasoned artist or just beginning, Artistic Expression Camp offers you the tools and guidance to unlock your creative potential.'},
    {'title': 'Astronomy Camp', 'description': 'Astronomy Camp offers a once-in-a-lifetime opportunity to explore the wonders of the night sky in the clear, vast desert sky. Under the guidance of expert astronomers, participants will learn how to identify stars, constellations, and planets. The camp features telescope viewings, night sky photography, and discussions about the science and mythology behind celestial bodies. Whether you’re an amateur stargazer or a seasoned astronomer, Astronomy Camp provides an immersive experience that allows you to connect with the cosmos and deepen your understanding of the universe.'},
    {'title': 'Sound Healing Camp', 'description': 'Sound Healing Camp offers a unique opportunity to tap into the therapeutic power of sound. Using a variety of instruments such as singing bowls, gongs, and chimes, participants will experience how different frequencies and vibrations can impact the mind, body, and spirit. The camp includes guided meditation sessions, sound baths, and individual healing experiences, all designed to promote deep relaxation, healing, and personal growth. Set against the calming desert landscape, Sound Healing Camp offers a serene space for rejuvenation and self-discovery.'},
    {'title': 'Paddleboarding Camp', 'description': 'Paddleboarding Camp offers an exciting blend of water adventures and desert beauty. Located in a desert oasis, this camp provides the perfect environment to learn or refine your paddleboarding skills. Whether you’re navigating calm waters or trying out exciting new techniques, you’ll have expert instructors by your side to guide you through every step. The camp also offers other water-based activities, such as kayaking and canoeing, all while surrounded by breathtaking desert views. Paddleboarding Camp is perfect for those looking to add some adventure to their desert retreat.'},
    {'title': 'Wilderness Survival Camp', 'description': 'Wilderness Survival Camp teaches you how to thrive in the wild. Set in the heart of the desert, this camp focuses on hands-on survival skills such as fire-starting, shelter-building, and water procurement. Experienced survival experts provide guidance and share essential techniques for surviving in harsh environments. You’ll also learn navigation, animal tracking, and food foraging, all designed to equip you with the knowledge and confidence to survive in the wilderness. Whether you’re an aspiring survivalist or just looking to challenge yourself, this camp offers a life-changing experience.'},
  ];

  final List<Map<String, String>> _events = [
    {'title': 'Burning Man Opening Ceremony', 'description': 'The Burning Man Opening Ceremony marks the beginning of a week-long celebration of art, community, and self-expression. It features live performances, music, and art installations that create a vibrant atmosphere of excitement and anticipation. The ceremony is an iconic event where participants gather to witness the lighting of the Man, a symbolic ritual that marks the start of the festival.'},
    {'title': 'Midnight Fire Dance', 'description': 'The Midnight Fire Dance is a captivating performance that showcases the mesmerizing art of fire dancing. With flames twirling and crackling in the dark, the dancers move in harmony with the rhythm of the fire, creating an unforgettable spectacle. This event is perfect for those who want to experience the magic and danger of fire in a captivating performance that celebrates the spirit of Burning Man.'},
    {'title': 'Full Moon Drum Circle', 'description': 'The Full Moon Drum Circle is a lively and energetic event where participants gather to drum and dance under the light of the full moon. The rhythmic beats of the drums echo through the desert, creating an infectious energy that brings people together in celebration. This event is open to everyone, whether you’re an experienced drummer or a beginner, and is a wonderful opportunity to connect with the Burning Man community.'},
    {'title': 'Sunset Sound Bath', 'description': 'The Sunset Sound Bath is a relaxing and meditative event that uses sound healing techniques to help participants unwind and reconnect with themselves. Set against the stunning backdrop of the desert sunset, the sound bath involves a variety of instruments such as gongs, singing bowls, and chimes, which produce soothing frequencies that wash over you. This tranquil experience provides an opportunity for deep relaxation and spiritual rejuvenation.'},
    {'title': 'Bicycle Parade', 'description': 'The Bicycle Parade is a lively and colorful event where participants decorate their bicycles and take to the streets in a celebration of creativity and movement. With dazzling lights and imaginative designs, the parade is a vibrant display of self-expression and joy. It’s a fun and energetic way to explore the playa while celebrating the spirit of Burning Man.'},
    {'title': 'Burning of the Man', 'description': 'The Burning of the Man is the most iconic event at Burning Man. This grand ritual involves the burning of a massive wooden effigy, symbolizing the culmination of the week’s festivities. As the flames engulf the structure, the community gathers around, reflecting on the transformative experiences and celebrating the impermanence of the art and life itself. The Burning of the Man is a poignant moment that connects participants to the deeper meaning of the festival.'},
    {'title': 'Desert Stargazing', 'description': 'Desert Stargazing offers a chance to connect with the cosmos under the clear, expansive night sky of the desert. Participants will have the opportunity to observe celestial bodies through telescopes and learn about the constellations from expert astronomers. It’s a serene and awe-inspiring experience that allows you to reflect on your place in the universe while surrounded by the beauty of the desert night.'},
    {'title': 'Art Parade', 'description': 'The Art Parade is a celebration of creativity, where artists and participants showcase their imaginative art pieces in a colorful and festive procession. The parade features a variety of art forms, from sculptures to performance art, and is a wonderful way to experience the diversity and innovation of the Burning Man community. The Art Parade is a vibrant expression of the festival’s theme of radical self-expression.'},
    {'title': 'Kinetic Sculpture Race', 'description': 'The Kinetic Sculpture Race is a thrilling competition where participants race self-propelled, human-powered art pieces through a challenging course of sand, dirt, and water. The sculptures are both functional and artistic, and the race celebrates creativity, engineering, and athleticism. This exciting event offers a unique opportunity to see art in motion while witnessing the ingenuity and determination of the participants.'},
    {'title': 'Silent Disco', 'description': 'Silent Disco is a unique dance experience where participants wear wireless headphones and dance to music broadcasted by live DJs. The music is only audible to those wearing the headphones, creating a surreal atmosphere where everyone is dancing to their own beat while surrounded by others in complete silence. The Silent Disco is a fun and unconventional way to enjoy music and connect with the Burning Man community.'},
  ];



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Explore BurnTech'),
          actions: [
            IconButton(
              icon: Icon(Icons.people),
              onPressed: () {
                // Navigate to the People page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserApiPage()),
                );
              },
            ),
          ],
          backgroundColor: Colors.deepOrangeAccent,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Art'),
              Tab(text: 'Camps'),
              Tab(text: 'Events'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildListView(_art), // Art Tab
            _buildListView(_camps), // Camps Tab
            _buildListView(_events), // Events Tab
          ],
        ),
      ),
    );
  }

  // Helper function to build a list view for each tab
  Widget _buildListView(List<Map<String, String>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child:
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              item['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              item['description']!.length > 100 ? item['description']!.substring(0,80) + '...'  : item['description']!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),

              // event['description'].length > 100 ? event['description'].substring(0, 80) + '...' : event['description'],
              // style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            onTap: () {
              // Navigate to details page (optional)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(title: item['title']!, description: item['description']!),
                ),
              );
            },
          ),

        );
      },
    );
  }
}

// Dummy details page
class DetailsPage extends StatelessWidget {
  final String title;
  final String description;

  const DetailsPage({Key? key, required this.title, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
          title: Text(title)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(description),
      ),
    );
  }
}
*/

