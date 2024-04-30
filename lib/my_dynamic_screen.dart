// my_dynamic_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Define the arguments class if needed
class MyCustomArguments {
  final String someValue;

  MyCustomArguments(this.someValue);
}

class MyDynamicScreen extends StatelessWidget {
  final MyCustomArguments args;

  const MyDynamicScreen({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Screen'),
      ),
      body: Center(
        child: Text('Passed argument: ${args.someValue}'),
      ),
    );
  }
}

// Define the unknown route screen
class UnknownRouteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unknown Route'),
      ),
      body: Center(
        child: Text('This route is not recognized.'),
      ),
    );
  }
}