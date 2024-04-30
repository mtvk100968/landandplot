import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedPropertyType;
  double? selectedPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Properties'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Apply the filters and return the result
              Navigator.pop(context);
            },
            child: Text(
              'Done',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Property Type'),
            trailing: DropdownButton<String>(
              value: selectedPropertyType,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPropertyType = newValue!;
                });
              },
              items: <String>['Agriculture land', 'Farm Land', 'Plot', 'Commercial Plot', 'Villa', 'Flat', 'Gated community Flat','Gated community Villa', 'Gated Community Plot'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text('Price'),
            trailing: DropdownButton<double>(
              value: selectedPrice,
              onChanged: (double? newValue) {
                setState(() {
                  selectedPrice = newValue!;
                });
              },
              items: <double>[10000000, 20000000, 30000000].map((double value) {
                return DropdownMenuItem<double>(
                  value: value,
                  child: Text('\$$value'),
                );
              }).toList(),
            ),
          ),
          // Add more filters as needed
        ],
      ),
    );
  }
}
