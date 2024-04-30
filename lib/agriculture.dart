import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Agriculture extends StatelessWidget {
  // Assuming you have these controllers declared elsewhere and passed in as parameters
  final TextEditingController pricePerAcreController;
  final TextEditingController totalAcresController;
  final TextEditingController totalLandPriceController;
  final VoidCallback onSelectionChanged; // Callback for when a dropdown value is selected

  Agriculture({
    Key? key,
    required this.pricePerAcreController,
    required this.totalAcresController,
    required this.totalLandPriceController,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define a local key for the form
    final _localFormKey = GlobalKey<FormState>();

    // Build the card for Agriculture type
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _localFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: pricePerAcreController,
                decoration: InputDecoration(labelText: 'Price per Acre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Land price per acre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: totalAcresController,
                decoration: InputDecoration(labelText: 'Total acres'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Total acres';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: totalLandPriceController,
                decoration: InputDecoration(labelText: 'Land total price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Total Land price';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
