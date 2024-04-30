import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'location_card.dart';

class GcPlotCard extends StatelessWidget {
  final TextEditingController propertyNameController;

  final TextEditingController pricePerYardController;
  final TextEditingController gcPlotAreaController;
  final TextEditingController gcPlotPriceController;

  GcPlotCard({
    Key? key,
    required this.propertyNameController,
    required this.pricePerYardController,
    required this.gcPlotAreaController,
    required this.gcPlotPriceController,
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
                      decoration: InputDecoration(labelText: 'Price Per SQY'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Price Per SQY';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller:
                          pricePerYardController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Price Per SQY'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Price Per SQY';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: gcPlotAreaController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Plot Area'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Villa Area';
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      controller:
                          gcPlotPriceController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Villa total Price';
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
