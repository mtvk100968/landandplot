import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'location_card.dart';

class VillaCard extends StatelessWidget {
  final TextEditingController propertyNameController;
  final TextEditingController pricePerSftController;
  final TextEditingController villaAreaInYardsController;
  final TextEditingController villaBuildAreaInSqftController;
  final TextEditingController villaCarpetAreaInSqftController;
  final TextEditingController villaPriceController;
  final TextEditingController villaBedroomsController;
  final TextEditingController villaBathroomsController;
  final TextEditingController villaBalconiesController;


  VillaCard({
    Key? key,
    required this.propertyNameController,
    required this.pricePerSftController,
    required this.villaAreaInYardsController,
    required this.villaBuildAreaInSqftController,
    required this.villaCarpetAreaInSqftController,
    required this.villaPriceController,
    required this.villaBedroomsController,
    required this.villaBathroomsController,
    required this.villaBalconiesController,


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
                      controller:
                      villaAreaInYardsController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Total Area in SQY'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Area in SQY';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: villaBuildAreaInSqftController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Villa Area'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Villa Area';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller:
                      villaCarpetAreaInSqftController, // Remove the underscore
                      decoration:
                          InputDecoration(labelText: 'Villa Carpet Area'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Villa Carpet Area';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: villaPriceController, // Remove the underscore
                      decoration:
                          InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Villa total Price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller:
                      villaBedroomsController, // Remove the underscore
                      decoration:
                      InputDecoration(labelText: 'Bedrooms'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Bedrooms count';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller:
                      villaBathroomsController, // Remove the underscore
                      decoration:
                      InputDecoration(labelText: 'Bathrooms'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter bathrooms count';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller:
                      villaBalconiesController, // Remove the underscore
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
