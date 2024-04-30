import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_card.dart';

class AgricultureCard extends StatelessWidget {
  final TextEditingController pricePerAcreController;
  final TextEditingController totalAcresController;
  final TextEditingController totalLandPriceController;

  AgricultureCard({
    Key? key,
    required this.pricePerAcreController,
    required this.totalAcresController,
    required this.totalLandPriceController,
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
                          pricePerAcreController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Price per Acre'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Price per Acre';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: totalAcresController, // Remove the underscore
                      decoration: InputDecoration(labelText: 'Total acres'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Total acres';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller:
                          totalLandPriceController, // Remove the underscore
                      decoration:
                          InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Land total price';
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
