import 'package:flutter/material.dart';

class TripCard extends StatelessWidget {
  final String name;
  final String country;
  final int duration;
  final int price;
  final String imageUrl;

  const TripCard({
    super.key,
    required this.name,
    required this.country,
    required this.duration,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('$country - ${duration} วัน'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text('ราคา ${price.toString()} บาท'),
          ),
        ],
      ),
    );
  }
}
