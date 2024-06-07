import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PropertyDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> details;
  final VoidCallback onTap;

  PropertyDetailsWidget({required this.details, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Debug prints to check data
    print('Price: ${details['price']}');
    print('Address: ${details['address']}');
    print('Bedrooms: ${details['bedrooms']}');
    print('Bathrooms: ${details['bathrooms']}');
    print('Area: ${details['area']}');
    print('Images: ${details['images']}');

    List<String> images = List<String>.from(details['images'] ?? []);

    return GestureDetector(
      onTap: onTap, // Call the onTap callback when the widget is tapped
      child: Container(
        height: 250, // Set the height of the container
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              height: 200, // Reduced height for the image
              width: double.infinity,
              child: images.isNotEmpty
                  ? CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  autoPlay: true,
                ),
                items: images.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.network(
                        image,
                        height: 200.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  );
                }).toList(),
              )
                  : Container(
                height: 200.0,
                width: double.infinity,
                color: Colors.grey[300],
                child: Center(
                  child: Text(
                    'No Image Available',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${details['price'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      details['address'] ?? 'Address: N/A',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Beds: ${details['bedrooms'] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Baths: ${details['bathrooms'] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Area: ${details['area'] ?? 'N/A'} sq ft',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}