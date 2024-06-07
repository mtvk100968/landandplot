// amenities_card.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AmenitiesCard extends StatefulWidget {
  final Function(Map<String, bool>) onAmenitiesChanged;

  AmenitiesCard({Key? key, required this.onAmenitiesChanged}) : super(key: key);

  @override
  _AmenitiesCardState createState() => _AmenitiesCardState();
}

class _AmenitiesCardState extends State<AmenitiesCard> {
  Map<String, bool> amenities = {
    'Internet': false,
    'Cctv': false,
    'Power Backup': false,
    'Fire Extinguishers': false,
    'Car Parking': false,
    'Gas Pipeline': false,
    'Intercom': false,
    'Security': false,
  };

  void _handleAmenityChange(String amenity, bool value) {
    setState(() {
      amenities[amenity] = value;
      widget.onAmenitiesChanged(amenities);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Amenities',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ...amenities.keys.map((String key) {
                  return SwitchListTile(
                    title: Text(key),
                    value: amenities[key]!,
                    onChanged: (bool value) => _handleAmenityChange(key, value),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}