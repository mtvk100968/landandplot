// lib/widgets/user_profile_image.dart

import 'package:flutter/material.dart';

class UserProfileImage extends StatelessWidget {
  final String imageUrl;

  UserProfileImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: imageUrl.isNotEmpty
          ? Image.network(
        imageUrl,
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Image.asset('assets/images/placeholder.png'); // Placeholder image
        },
      )
          : Image.asset('assets/images/placeholder.png'), // Placeholder if URL is empty
    );
  }
}