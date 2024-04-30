import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_card.dart';

class ApartmentCard extends StatelessWidget {
  final TextEditingController propertyNameController;
  final TextEditingController pricePerSftController;
  final TextEditingController aptAreaInSqftController;
  final TextEditingController aptCarpetAreaController;
  final TextEditingController aptPriceController;
  final TextEditingController aptBedroomsController;
  final TextEditingController aptBathroomsController;
  final TextEditingController aptBalconiesController;

  ApartmentCard({
    Key? key,
    required this.propertyNameController,
    required this.pricePerSftController,
    required this.aptAreaInSqftController,
    required this.aptCarpetAreaController,
    required this.aptPriceController,
    required this.aptBedroomsController,
    required this.aptBathroomsController,
    required this.aptBalconiesController,

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
                      decoration: InputDecoration(labelText: 'Price per SFT'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Price per SFT';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: aptAreaInSqftController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Total Area'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Total Area';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller:
                          aptCarpetAreaController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Apt Carpet Area'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Apt Carpet Area';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: aptPriceController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Apt price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller:
                      aptBedroomsController, // Remove the underscore
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
                      aptBathroomsController, // Remove the underscore
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
                      aptBalconiesController, // Remove the underscore
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
