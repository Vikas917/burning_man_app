import 'package:flutter/material.dart';

class CampListTile extends StatelessWidget {
  final Map<String, dynamic> camp;

  CampListTile({required this.camp});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(camp['name']),
      subtitle: Text(camp['description']),
      onTap: () {
        Navigator.pushNamed(context, '/camp', arguments: camp);
      },
    );
  }
}
