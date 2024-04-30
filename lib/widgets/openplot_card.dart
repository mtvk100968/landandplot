import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'location_card.dart';

class OpenPlotCard extends StatelessWidget {
  final TextEditingController pricePerYardController;
  final TextEditingController totalAreaInYardsController;
  final TextEditingController totalOLandPriceController;

  OpenPlotCard({
    Key? key,
    required this.pricePerYardController,
    required this.totalAreaInYardsController,
    required this.totalOLandPriceController,
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
                          pricePerYardController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Price Per Yard'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Price Per Yard';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: totalAreaInYardsController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Total Yards'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Total Yards';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller:
                          totalOLandPriceController, // Remove the underscore
                      decoration:
                          InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Plot Total Price';
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
