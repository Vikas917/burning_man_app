import 'package:flutter/material.dart';

class NowPage extends StatelessWidget {
  const NowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent[50],
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text("Now Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Check back once you get \n \t\t\t\t\t\t to Burning Man',
          style: TextStyle(
            fontSize: 24, // Adjust font size if needed
            color: Colors.black, // Normal text color
          ),
        ),
      ),
    );
  }
}
