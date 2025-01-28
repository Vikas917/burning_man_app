import 'package:flutter/material.dart';

class NowPage extends StatelessWidget {
  const NowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Now Page"),
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
