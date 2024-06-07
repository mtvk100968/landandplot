// commercial_space_card.dart
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:landandplot/widgets/regular_amenities_card.dart';
import 'package:permission_handler/permission_handler.dart';
import 'location_card.dart';

class CommercialSpaceCard extends StatefulWidget {
  final TextEditingController propertyIdController;
  final TextEditingController mobileNoController;
  final TextEditingController propertyNameController;
  final TextEditingController propertyOwnerNameController;
  final TextEditingController rentPerMonthController;
  final TextEditingController advanceRentController;
  final TextEditingController areaInSqftController;
  final TextEditingController carpetAreaController;
  final TextEditingController shatterLengthController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final Map<String, dynamic> propertyDetails;
  final Function(Map<String, dynamic>) onSave;
  CommercialSpaceCard({
    Key? key,
    required this.propertyIdController,
    required this.mobileNoController,
    required this.propertyNameController,
    required this.propertyOwnerNameController,
    required this.areaInSqftController,
    required this.carpetAreaController,
    required this.rentPerMonthController,
    required this.advanceRentController,
    required this.shatterLengthController,
    required this.propertyDetails,
    required this.onSave,
    required this.latitudeController,
    required this.longitudeController,
  }) : super(key: key);

  @override
  _CommercialSpaceCardState createState() => _CommercialSpaceCardState();
}

class _CommercialSpaceCardState extends State<CommercialSpaceCard> {
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFileList = [];
  bool _isSubmitting = false;
  bool _showDetails = false;

  void _handleMapTap(LatLng position) {
    FocusScope.of(context).unfocus();
    setState(() {
      _showDetails = false;
    });
  }

  Map<String, bool> rguler_amenities = {
    'Ghmc Water': false,
    'Lift': false,
    'Power Backup': false,
    'Bike Parking': false,
    'Car Parking': false,
  };

  void _onMapCreated(GoogleMapController controller) {}

  Future<void> _requestPermissions() async {
    await Permission.photos.request();
    await Permission.storage.request();
    await Permission.camera.request();
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _pickImages() async {
    await _requestPermissions();

    try {
      final List<XFile>? pickedFileList = await _picker.pickMultiImage();

      if (pickedFileList != null && pickedFileList.isNotEmpty) {
        setState(() {
          _imageFileList = pickedFileList;
        });
      } else {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            _imageFileList = [image];
          });
        }
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void _handleAmenitiesChanged(Map<String, bool> updatedAmenities) {
    setState(() {
      rguler_amenities = updatedAmenities;
    });
  }

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
                      controller: widget.propertyIdController,
                      decoration: InputDecoration(labelText: 'Mobile No'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Mobile no';
                        }
                        if (!RegExp(r'^\+?[0-9]{0,12}$').hasMatch(value)) {
                          return 'Please enter a valid Mobile no';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9]*$')),
                        LengthLimitingTextInputFormatter(12),
                      ],
                    ),
                    TextFormField(
                      controller: widget.propertyNameController,
                      decoration: InputDecoration(labelText: 'Property Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Property Name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: widget.rentPerMonthController,
                      decoration: InputDecoration(labelText: 'Apartment Area'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Apartment Area';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: widget.areaInSqftController,
                      decoration: InputDecoration(labelText: 'Apartment Area'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Apartment Area';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: widget.carpetAreaController,
                      decoration: InputDecoration(labelText: 'Apartment Carpet Area'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Apartment Carpet Area';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: widget.advanceRentController,
                      decoration: InputDecoration(labelText: 'Bathrooms'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter bathrooms count';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: widget.shatterLengthController,
                      decoration: InputDecoration(labelText: 'Balconies'),
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
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Attach Images',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: _pickImages,
                    child: Text('Pick Images'),
                  ),
                  if (_imageFileList.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _imageFileList.map((image) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              File(image!.path),
                              width: 100,
                              height: 100,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _handleMapTap(LatLng(0, 0));
            },
            child: LocationCard(
              initialPosition: LatLng(17.3850, 78.4867),
              height: 400,
              width: MediaQuery.of(context).size.width,
              latitudeController: _latController,
              longitudeController: _lngController,
              onMapCreated: _onMapCreated,
            ),
          ),
          RegularAmenitiesCard(
            onAmenitiesChanged: _handleAmenitiesChanged,
          ),
        ],
      ),
    );
  }
}