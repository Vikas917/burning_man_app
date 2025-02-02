import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CampApiPage extends StatefulWidget {
  @override
  _CampApiPageState createState() => _CampApiPageState();
}

class _CampApiPageState extends State<CampApiPage> {
  List<dynamic> campItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCampData();
  }

  // Function to fetch camp data from the API
  Future<void> fetchCampData() async {
    final url = 'https://api.burningman.org/api/v1/camp?year=2015';
    final uri = Uri.parse(url);

    // Credentials: API Key
    final encodedCredentials = base64Encode(utf8.encode('8b036b6e8f668d5267a493568078d8d1:'));


    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Basic $encodedCredentials',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          campItems = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load camp data. Status code: ${response.statusCode}');
        throw Exception('Failed to load camp data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      // appBar: AppBar(
      //   // backgroundColor: Colors.deepOrangeAccent,
      //   // centerTitle: true,
      //   //title: Text('Burning Man Camps 2015'),
      // ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: campItems.length,
        itemBuilder: (context, index) {
          final camp = campItems[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'), // Starts from 1
            ),
            title: Text(camp['name'] ?? 'No Name',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            subtitle: Text(camp['hometown'] ?? 'No Hometown'),
            onTap: () {
              // Navigate to a new screen to show camp details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CampDetailPage(camp: camp),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchCampData,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class CampDetailPage extends StatelessWidget {
  final dynamic camp;

  CampDetailPage({required this.camp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        title: Text(camp['name'] ?? 'No Name'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // Wrap the Column with SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                camp['name'] ?? 'No Name',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Hometown:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // Bold for Hometown
                  ),
                  SizedBox(width: 8),  // Space between the label and data
                  Text(
                    camp['hometown'] ?? 'Unknown',
                    style: TextStyle(fontSize: 16),  // Different style for the data
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Description:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // Bold for Description
                  ),
                  SizedBox(width: 8),  // Space between the label and data
                  Expanded(
                    child: Text(
                      camp['description'] ?? 'No Description',
                      style: TextStyle(fontSize: 16),  // Different style for the data
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              if (camp['location'] != null)
                Row(
                  children: [
                    Text(
                      'Location:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // Bold for Location
                    ),
                    SizedBox(width: 8),  // Space between the label and data
                    Text(
                      camp['location']['string'] ?? 'Unknown',
                      style: TextStyle(fontSize: 16),  // Different style for the data
                    ),
                  ],
                ),
              SizedBox(height: 8),
              if (camp['url'] != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Website:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // Bold for Website
                    ),
                    SizedBox(width: 8),
                    Text(
                      camp['url'] ?? 'No URL',
                      style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),  // Link style for Website
                    ),
                  ],
                ),
              SizedBox(height: 8),
              if (camp['contact_email'] != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Email:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // Bold for Contact Email
                    ),
                    SizedBox(width: 8),
                    Text(
                      camp['contact_email'] ?? 'No Email',
                      style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),  // Link style for Email
                    ),
                  ],
                ),


            ],
          ),
        ),
      ),
    );
  }
}
