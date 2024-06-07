// property_image_screen.dart
import 'package:flutter/material.dart';

class PropertyImagesScreen extends StatelessWidget {
  final List<String> imageUrls;

  PropertyImagesScreen({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Images'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: imageUrls.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemBuilder: (context, index) {
          return Image.network(
            imageUrls[index],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error);
            },
          );
        },
      ),
    );
  }
}