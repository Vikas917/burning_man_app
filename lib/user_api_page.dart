
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
/*
class UserApiPage extends StatefulWidget {
  @override
  _UserApiPageState createState() => _UserApiPageState();
}

class _UserApiPageState extends State<UserApiPage> {
  late Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    posts = fetchPosts();
  }

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(
      Uri.parse('https://api.wemotions.app/posts/fetch/all'),
      headers: {
        'Flic-Token': 'flic_d4500eeca0ab6c3c28003a87c94794c6bdb7a0406934f8b105a1dbf8abe2e011',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> postList = data['posts'];
      return postList.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts from API'),
      ),
      body: FutureBuilder<List<Post>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available'));
          } else {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    leading: Image.network(post.thumbnailUrl),
                    title: Text(post.title),
                    subtitle: Text('Views: ${post.viewCount} | Upvotes: ${post.upvoteCount}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailPage(post: post),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchPosts,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class Post {
  final String title;
  final String videoLink;
  final String thumbnailUrl;
  final int viewCount;
  final int upvoteCount;

  Post({
    required this.title,
    required this.videoLink,
    required this.thumbnailUrl,
    required this.viewCount,
    required this.upvoteCount,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
      videoLink: json['video_link'],
      thumbnailUrl: json['thumbnail_url'],
      viewCount: json['view_count'],
      upvoteCount: json['upvote_count'],
    );
  }
}

class PostDetailPage extends StatefulWidget {
  final Post post;

  PostDetailPage({required this.post});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.post.videoLink)
      ..addListener(() {
        setState(() {});
      })
      ..initialize().then((_) {
        setState(() {});
      });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.post.title)),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels > MediaQuery.of(context).size.height * 0.8) {
            if (!_controller.value.isPlaying) {
              _controller.play();
            }
          } else {
            if (_controller.value.isPlaying) {
              _controller.pause();
            }
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image Section (80% of the screen initially)
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    widget.post.thumbnailUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Post Info (scrolls with content)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.post.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    //SizedBox(height: 5),
                    Text(
                      'Views: ${widget.post.viewCount} | Upvotes: ${widget.post.upvoteCount}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    //SizedBox(height: 15),
                  ],
                ),
              ),

              // Video Section (Appears on scrolling, takes the remaining space)
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: double.infinity,
                child: _controller.value.isInitialized
                    ? Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatDuration(_controller.value.position),
                              style: TextStyle(color: Colors.black)),
                          Expanded(
                            child: VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                playedColor: Colors.blue,
                                bufferedColor: Colors.grey,
                                backgroundColor: Colors.black12,
                              ),
                            ),
                          ),
                          Text(formatDuration(_controller.value.duration),
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    Positioned(
                      child: IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          size: 70,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                      ),
                    ),
                  ],
                )
                    : Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
*/






class UserApiPage extends StatefulWidget {
  const UserApiPage({super.key});

  @override
  State<UserApiPage> createState() => _UserApiPageState();
}

class _UserApiPageState extends State<UserApiPage> {
  List<dynamic> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text('Burning Man Users'),
      ),
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())  // Loading indicator
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final name = user['name'] ?? 'No Name';
          final imageUrl = user['profile_picture'] ?? '';
          final email = user['phone_number'] ?? '';

          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl)
                  : const Icon(Icons.person),
            ),
            title: Text(name,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            subtitle: Text(email),
            onTap: () {
              // Navigate to the patient detail page on tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientDetailPage(user: user),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUsers,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void fetchUsers() async {
    print('Fetching users...');
    const url = 'https://fedskillstest.coalitiontechnologies.workers.dev';
    final uri = Uri.parse(url);

    // Credentials: Username = 'coalition', Password = 'skills-test'
    final encodedCredentials = base64Encode(utf8.encode('coalition:skills-test'));

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Basic $encodedCredentials',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('Response: $json');

        if (json is List) {
          setState(() {
            users = json;
          });
        } else if (json['results'] is List) {
          setState(() {
            users = json['results'];
          });
        } else {
          print('The response does not contain the expected "results" field.');
        }
      } else {
        print('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }
}

class PatientDetailPage extends StatelessWidget {
  final dynamic user;

  const PatientDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final name = user['name'] ?? 'No Name';
    final imageUrl = user['profile_picture'] ?? '';
    final phoneNumber = user['phone_number'] ?? 'No Phone Number';
    final emergencyContact = user['emergency_contact'] ?? 'No Emergency Contact';
    final insuranceType = user['insurance_type'] ?? 'No Insurance';
    final diagnosisHistory = user['diagnosis_history'] ?? [];

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(name),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Profile Picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(125), // Rounded profile picture
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                    imageUrl,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.person, size: 150), // Default icon if no image
                ),
                const SizedBox(height: 16),
                // Patient Details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        'Name:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(name, style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),

                      // Phone Number
                      Text(
                        'Phone:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(phoneNumber, style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),

                      // Emergency Contact
                      Text(
                        'Emergency Contact:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(emergencyContact, style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),

                      // Insurance Type
                      Text(
                        'Insurance:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(insuranceType, style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                // Diagnosis History Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'History:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final diagnosis = diagnosisHistory[index];
                return ListTile(
                  title: Text(
                    '${diagnosis['month']} ${diagnosis['year']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Blood Pressure: ${diagnosis['blood_pressure']}',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              },
              childCount: diagnosisHistory.length,
            ),
          ),
        ],
      ),
    );
  }
}




/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserApiPage extends StatefulWidget {
  const UserApiPage({super.key});

  @override
  State<UserApiPage> createState() => _UserApiPageState();
}

class _UserApiPageState extends State<UserApiPage> {
  List<dynamic> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Data'),
      ),
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())  // Loading indicator
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          // Print the user object for debugging purposes
          print('User data: $user');
          final name = user['name'] ?? 'No Name';  // Ensure default values
          final imageUrl = user['profile_picture'] ?? '';
          final email = user['phone_number'] ?? '';

          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl)
                  : const Icon(Icons.person), // Show a placeholder if no image
            ),
            title: Text(name),
            subtitle: Text(email),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUsers,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void fetchUsers() async {
    print('Fetching users...');
    const url = 'https://fedskillstest.coalitiontechnologies.workers.dev';
    final uri = Uri.parse(url);

    // Credentials: Username = 'coalition', Password = 'skills-test'
    final encodedCredentials = base64Encode(utf8.encode('coalition:skills-test'));

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Basic $encodedCredentials',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('Response: $json');  // Print the full response for debugging

        // Check if the 'results' field is a List
        if (json is List) {
          setState(() {
            users = json;  // Update users with the data from the API response
          });
        } else if (json['results'] is List) {
          setState(() {
            users = json['results'];  // If 'results' is present
          });
        } else {
          print('The response does not contain the expected "results" field.');
        }
      } else {
        print('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }
}
*/

/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserApiPage extends StatefulWidget {
  const UserApiPage({super.key});

  @override
  State<UserApiPage> createState() => _UserApiPageState();
}

class _UserApiPageState extends State<UserApiPage> {
  List<dynamic> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API Call'),
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final name = user['name']['last'];
            final imageUrl = user['picture']['thumbnail'];
            final email = user['email'];

            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(imageUrl),
              ),
              title: Text(name),
              subtitle: Text(email),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: fetchUsers
      ),
    );
  }

  void fetchUsers() async {
    print('fetch user called');
    const url = 'https://randomuser.me/api/?results=100';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    setState(() {
      users = json['results'];
    });

    print('fetch user completed');
  }
}

 */