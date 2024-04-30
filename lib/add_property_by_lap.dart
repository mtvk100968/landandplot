// add_property_by_lap.dart
import 'package:flutter/material.dart';
import 'package:landandplot/services/firestore_database_service.dart';
import 'package:landandplot/models/property_address.dart';
class AddPropertyByLap extends StatefulWidget {
  @override
  _AddPropertyByLapState createState() => _AddPropertyByLapState();
}
class _AddPropertyByLapState extends State<AddPropertyByLap> {

  // Define a list of dropdown menu items
  final List<DropdownMenuItem<String>> propertyTypeItems = [
    DropdownMenuItem(value: "Agriculture Land", child: Text("Agriculture Land")),
    DropdownMenuItem(value: "Farm Land", child: Text("Farm Land")),
    DropdownMenuItem(value: "Commercial Plot", child: Text("Commercial Plot")),
    DropdownMenuItem(value: "Open Plot", child: Text("Open Plot")),
    DropdownMenuItem(value: "Villa", child: Text("Villa")),
    DropdownMenuItem(value: "Apartment", child: Text("Apartment")),
    DropdownMenuItem(value: "Gated Community Plot", child: Text("Gated Community Plot")),
    DropdownMenuItem(value: "Gated Community Villa", child: Text("Gated Community Villa")),
    DropdownMenuItem(value: "Gated Community Aprt", child: Text("Gated Community Aprt")),
  ];

  String? selectedPropertyType;
  final _formKey = GlobalKey<FormState>();
  final _propertyIdController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _priceController = TextEditingController();
  final _userIdControllor = TextEditingController();
  final _dbService = FirestoreDatabaseService();

  // Inside _AddPropertyByLapState
  bool _isSubmitting = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    _propertyIdController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _priceController.dispose();
    _userIdControllor.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate() && selectedPropertyType != null) {
      setState(() {
        _isSubmitting = true;
      });

      var newProperty = PropertyAddress(
        propertyId: _propertyIdController.text,
        propertyType: selectedPropertyType!,
        latitude: double.parse(_latController.text),
        longitude: double.parse(_lngController.text),
        iconPath: 'assets/icons/gps.png', // Assuming you have an icon in the assets
        price: _priceController.text,
        userId: _userIdControllor.text,
      );

      try {
        await _addPropertyToDatabase(newProperty);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Property added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add property: $e')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }


  Future<void> _addPropertyToDatabase(PropertyAddress property) async {
    try {
      Map<String, dynamic> propertyMap = property.toMap(); // Convert property to Map
      await _dbService.addOrUpdateProperty(property.propertyId, propertyMap); // Pass both propertyId and Map
      // Navigate back or show success message
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Property added successfully')),
      );
    } catch (e) {
      // Handle any errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add property: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Property'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _propertyIdController,
              decoration: InputDecoration(labelText: 'Property ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a property ID';
                }
                return null;
              },
            ),

            // Inside your build method, include this widget where you want the dropdown
            DropdownButtonFormField<String>(
              value: selectedPropertyType,
              // hint: Text("Select Property Type"),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPropertyType = newValue;
                });
              },
              items: propertyTypeItems,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a property type';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _latController,
              decoration: InputDecoration(labelText: 'Latitude'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter latitude';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lngController,
              decoration: InputDecoration(labelText: 'Longitude'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter longitude';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the price';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _userIdControllor,
              decoration: InputDecoration(labelText: 'UserId'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the userId';
                }
                return null;
              },
            ),
            // Inside the build method for the ElevatedButton
            ElevatedButton(
              onPressed: _isSubmitting ? null : _handleSubmit,
              child: _isSubmitting ? CircularProgressIndicator() : Text('Add Property'),
            ),
          ],
        ),
      ),
    );
  }
}
