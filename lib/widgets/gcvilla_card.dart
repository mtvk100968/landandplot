import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'location_card.dart';

class GcVillaCard extends StatelessWidget {

  final TextEditingController propertyNameController;
  final TextEditingController pricePerSftController;
  final TextEditingController areaInYardsController;
  final TextEditingController gcVillaCarpetAreaController;
  final TextEditingController gcVillaPriceController;
  final TextEditingController gcVillaBedroomsController;
  final TextEditingController gcVillaBathroomsController;
  final TextEditingController gcVillaBalconiesController;

  GcVillaCard({
    Key? key,
    required this.propertyNameController,
    required this.pricePerSftController,
    required this.areaInYardsController,
    required this.gcVillaCarpetAreaController,
    required this.gcVillaPriceController,
    required this.gcVillaBedroomsController,
    required this.gcVillaBathroomsController,
    required this.gcVillaBalconiesController,

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
                      areaInYardsController, // Remove the underscore
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
                          gcVillaCarpetAreaController, // Remove the underscore
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
                      controller:
                          gcVillaPriceController, // Remove the underscore
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
                      gcVillaBedroomsController, // Remove the underscore
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
                      gcVillaBathroomsController, // Remove the underscore
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
                      gcVillaBalconiesController, // Remove the underscore
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
