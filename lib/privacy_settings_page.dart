import 'package:flutter/material.dart';
import 'package:landandplot/privacy_option_card.dart';

class PrivacySettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LandandPlot Privacy Center'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          PrivacyOptionCard(
            icon: Icons.lock_outline,
            text: 'Opt Out and Communication Preference',
            onTap: () {
              // Handle tap
            },
          ),
          SizedBox(height: 10), // Gap between cards
          PrivacyOptionCard(
            icon: Icons.camera_alt_outlined,
            text: 'Property Photo Removal',
            onTap: () {
              // Handle tap
            },
          ),
          SizedBox(height: 10), // Gap between cards
          PrivacyOptionCard(
            icon: Icons.description_outlined,
            text: 'Terms Of Service',
            onTap: () {
              // Handle tap
            },
          ),
          SizedBox(height: 10), // Gap between cards
          PrivacyOptionCard(
            icon: Icons.policy_outlined,
            text: 'Privacy Policy',
            onTap: () {
              // Handle tap
            },
          ),
          SizedBox(height: 10), // Gap between cards
          PrivacyOptionCard(
            icon: Icons.rule_folder_outlined,
            text: 'Indian RERA Rules',
            onTap: () {
              // Handle tap
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '© 2024 LandandPlot. Your Privacy Choices',
          style: TextStyle(
              // Style similar to the one in the image
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
