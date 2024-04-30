// email_signin_screen.dart
import 'package:flutter/material.dart';

class EmailSigninScreen extends StatelessWidget {
  static const routeName =
      '/email_signin_screen'; // Add this line if not already present

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up with Email')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          // ... Email Signup UI ...
        ),
      ),
    );
  }
}
