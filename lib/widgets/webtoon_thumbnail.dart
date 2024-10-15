import 'package:flutter/material.dart';

class WebtoonThumbnail extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Function onTap;

  const WebtoonThumbnail(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        children: [
          Image.network(imageUrl, height: 150, fit: BoxFit.cover),
          // Image.asset(imageUrl, fit: BoxFit.cover),
          SizedBox(height: 8),
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
