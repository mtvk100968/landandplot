import 'package:flutter/material.dart';
import 'property_service.dart'; // Adjust the import path accordingly

class PropertyListWidget extends StatefulWidget {
  @override
  _PropertyListWidgetState createState() => _PropertyListWidgetState();
}

class _PropertyListWidgetState extends State<PropertyListWidget> {
  late Future<List<dynamic>> propertyList;

  @override
  void initState() {
    super.initState();
    propertyList = PropertyService().loadProperties();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: propertyList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              var property = snapshot.data?[index];
              return ListTile(
                title: Text('Property ID: ${property['propertyId']}'),
                subtitle: Text('Location: ${property['latitude']}, ${property['longitude']}'),
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
