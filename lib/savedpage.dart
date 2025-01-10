import 'package:flutter/material.dart';

class savedpage extends StatelessWidget {
  const savedpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Articles are saved yet,start now',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

