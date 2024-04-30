// privacy_option_card.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrivacyOptionCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const PrivacyOptionCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0), // This makes the corners sharp.
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.lightBlue.withAlpha(30), // Ripple effect color on tap        child: Padding(
        child: Padding(
          padding: const EdgeInsets.all(16.0),          child: Column(
            children: [
              Icon(
                icon,
                size: 50, // Adjust the size of the icon as per your design.
              ),
              SizedBox(height: 12), // Provides space between icon and text.
              Text(
                text,
                style: TextStyle(
                  fontSize: 20, // Adjust the font size as per your design.
                  fontWeight: FontWeight.bold, // Makes the text bold.
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}