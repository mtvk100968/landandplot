import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'location_card.dart';

class GcAptCard extends StatelessWidget {
  final TextEditingController propertyNameController;
  final TextEditingController pricePerSftController;
  final TextEditingController gcAptAreaController;
  final TextEditingController gcAptCarpetAreaController;
  final TextEditingController gcAptPriceController;
  final TextEditingController gcAptBedroomsController;
  final TextEditingController gcAaptBathroomsController;
  final TextEditingController gcAptBalconiesController;

  GcAptCard({
    Key? key,
    required this.propertyNameController,
    required this.pricePerSftController,
    required this.gcAptAreaController,
    required this.gcAptCarpetAreaController,
    required this.gcAptPriceController,
    required this.gcAptBedroomsController,
    required this.gcAaptBathroomsController,
    required this.gcAptBalconiesController,
  }) : super(key: key);
  // Since this is a stateless widget, _formKey cannot be constant if you expect the form to change.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller:
                      propertyNameController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Property Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Property Name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller:
                          pricePerSftController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Price Per SFT'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Price Per SFT';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: gcAptAreaController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Aapartment Area'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Aapartment Area';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller:
                          gcAptCarpetAreaController, // Remove the underscore
                      decoration:
                          InputDecoration(labelText: 'Aapartment Carpet Area'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Aapartment Carpet Area';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: gcAptPriceController, // Remove the underscore
                      decoration:
                          InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Aapartment Price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: gcAptBedroomsController, // Remove the underscore
                      decoration:  InputDecoration(labelText: 'Bedrooms'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Bedrooms count';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: gcAaptBathroomsController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Bathrooms'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter bathrooms count';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller:
                      gcAptBalconiesController, // Remove the underscore
                      decoration:
                      InputDecoration(labelText: 'Balconies'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Balconies count';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          LocationCard(
            initialPosition:
                LatLng(17.3850, 78.4867), // Replace with dynamic data if needed
            height: 400,
            width: MediaQuery.of(context).size.width,
            onMapCreated: (GoogleMapController controller) {
              // Handle map creation
            },
          ),
        ],
      ),
    );
  }
}
