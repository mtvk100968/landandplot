// extraamenities_card.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExtraAmenitiesCard extends StatefulWidget {
  final Function(Map<String, bool>) onExtraAmenitiesChanged;

  ExtraAmenitiesCard({Key? key, required this.onExtraAmenitiesChanged})
      : super(key: key);

  @override
  _ExtraAmenitiesCardState createState() => _ExtraAmenitiesCardState();
}

class _ExtraAmenitiesCardState extends State<ExtraAmenitiesCard> {
  Map<String, bool> amenities = {
    'Gym': false,
    'Jogging Park': false,
    'Spa': false,
    'Swimming Pool': false,
    'Indoor Games': false,
    'Grocery Shop': false,
    'Sports Ground': false,
    'Yoga': false,
    'Shuttle Court': false,
    'Pre-school': false,
    'Shuttle': false,
    'Fire Sensor': false,
  };

  void _handleExtraAmenityChange(String amenity, bool value) {
    setState(() {
      amenities[amenity] = value;
      widget.onExtraAmenitiesChanged(amenities);
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
                    'Extra Amenities',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge, // Updated to use titleLarge
                  ),
                ),
                ...amenities.keys.map((String key) {
                  return SwitchListTile(
                    title: Text(key),
                    value: amenities[key]!,
                    onChanged: (bool value) =>
                        _handleExtraAmenityChange(key, value),
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