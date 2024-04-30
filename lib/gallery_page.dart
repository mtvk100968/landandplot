// gallery_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  //const GalleryPage({Key? key, required this.imageUrls}) : super(key: key);
// Make sure to initialize both imageUrls and initialIndex in the constructor
  const GalleryPage({Key? key, required this.imageUrls, this.initialIndex = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // Adjust the number of columns here
          childAspectRatio: 1.0, // Adjust the aspect ratio of the images
        ),
        itemCount: imageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.asset(
            imageUrls[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
