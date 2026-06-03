import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Enjoy the best movie experience with our seamless ticket booking system. Explore the latest releases and secure your seats in just a few clicks.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            height: 1.5,
          ),
        ),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.discord, color: Colors.grey, size: 20),
            SizedBox(width: 20),
            Icon(Icons.telegram, color: Colors.grey, size: 20),
            SizedBox(width: 20),
            Icon(Icons.email, color: Colors.grey, size: 20),
          ],
        ),
      ],
    );
  }
}