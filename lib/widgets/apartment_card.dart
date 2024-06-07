import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/storage_service.dart';
import 'amenities_card.dart';
import 'extra_amenities_card.dart';
import 'location_card.dart';

class ApartmentCard extends StatefulWidget {
  final TextEditingController propertyIdController;
  final TextEditingController mobileNoController;
  final TextEditingController propertyNameController;
  final TextEditingController rentPerMonthController;
  final TextEditingController areaInSqftController;
  final TextEditingController carpetAreaController;
  final TextEditingController advanceRentController;
  final TextEditingController bedRoomsController;
  final TextEditingController bathRoomsController;
  final TextEditingController balConiesController;
  final Map<String, dynamic> propertyDetails;
  final Function(Map<String, dynamic>) onSave;

  ApartmentCard({
    Key? key,
    required this.propertyIdController,
    required this.mobileNoController,
    required this.propertyNameController,
    required this.rentPerMonthController,
    required this.areaInSqftController,
    required this.carpetAreaController,
    required this.advanceRentController,
    required this.bedRoomsController,
    required this.bathRoomsController,
    required this.balConiesController,
    required this.propertyDetails,
    required this.onSave,
  }) : super(key: key);

  @override
  _ApartmentCardState createState() => _ApartmentCardState();
}

class _ApartmentCardState extends State<ApartmentCard> {
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFileList = [];
  bool _isSubmitting = false;
  bool _showDetails = false;

  void _onMapCreated(GoogleMapController controller) {}

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

  Future<void> _requestPermissions() async {
    final PermissionStatus photosPermission = await Permission.photos.request();
    final PermissionStatus storagePermission = await Permission.storage.request();
    final PermissionStatus cameraPermission = await Permission.camera.request();

    if (photosPermission.isDenied || storagePermission.isDenied || cameraPermission.isDenied) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permissions Required'),
            content: Text('Please grant all the required permissions to proceed.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _savePropertyDetails(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      List<String> imageUrls = [];
      for (XFile image in _imageFileList) {
        String? url = await StorageService.uploadImage(image.path, widget.propertyIdController.text);
        imageUrls.add(url!);
      }

      FirebaseFirestore.instance.collection('properties').add({
        'propertyId': widget.propertyIdController.text,
        'mobileNo': widget.mobileNoController.text,
        'propertyName': widget.propertyNameController.text,
        'rentPerMonth': int.parse(widget.rentPerMonthController.text),
        'areaInSqft': int.parse(widget.areaInSqftController.text),
        'carpetArea': int.parse(widget.carpetAreaController.text),
        'advanceRent': int.parse(widget.advanceRentController.text),
        'bedRooms': int.parse(widget.bedRoomsController.text),
        'bathRooms': int.parse(widget.bathRoomsController.text),
        'balConies': int.parse(widget.balConiesController.text),
        'latitude': double.parse(_latController.text),
        'longitude': double.parse(_lngController.text),
        'imageUrls': imageUrls, // Store uploaded image URLs in Firestore
        'amenities': amenities,
        'extraAmenities': extraAmenities,
      }).then((value) {
        widget.propertyIdController.clear();
        widget.mobileNoController.clear();
        widget.propertyNameController.clear();
        widget.rentPerMonthController.clear();
        widget.areaInSqftController.clear();
        widget.carpetAreaController.clear();
        widget.advanceRentController.clear();
        widget.bedRoomsController.clear();
        widget.bathRoomsController.clear();
        widget.balConiesController.clear();
        _latController.clear();
        _lngController.clear();

        setState(() {
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Property details saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }).catchError((error) {
        setState(() {
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save property details: $error'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    }
  }

  void _handleMapTap(LatLng position) {
    FocusScope.of(context).unfocus();
    setState(() {
      _showDetails = false;
    });
  }

  Map<String, bool> amenities = {
    'Internet': false,
    'Cctv': false,
    'Power Backup': false,
    'Fire Extinguishers': false,
    'Car Parking': false,
    'Gas Pipeline': false,
    'Intercom': false,
    'Security': false,
  };

  Map<String, bool> extraAmenities = {
    'Gym': false,
    'Jogging Park': false,
    'Spa': false,
    'Swimming Pool': false,
    'Indoor Games': false,
    'Grocery Shop': false,
    'Sports Ground': false,
    'Yoga': false,
    'Shuttle Court': false,
    'Pre-school': false,
    'Shuttle': false,
    'Fire Sensor': false,
  };

  void _handleAmenitiesChanged(Map<String, bool> updatedAmenities) {
    setState(() {
      amenities = updatedAmenities;
    });
  }

  void _handleExtraAmenitiesChanged(Map<String, bool> updatedExtraAmenities) {
    setState(() {
      extraAmenities = updatedExtraAmenities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
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
                        decoration: InputDecoration(labelText: 'Property ID'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Property ID';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: widget.mobileNoController,
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
                        decoration: InputDecoration(
                          labelText: 'Property Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Property Name';
                          }
                          return null;
                        },
                        maxLength: 100,
                        maxLines: null,
                      ),
                      TextFormField(
                        controller: widget.areaInSqftController,
                        decoration: InputDecoration(labelText: 'Total Area'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Total Area';
                          }
                          final area = int.tryParse(value);
                          if (area == null || area < 0 || area > 10000) {
                            return 'Please enter a valid Total Area (up to 10,000 sqft)';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5),
                        ],
                      ),
                      TextFormField(
                        controller: widget.carpetAreaController,
                        decoration: InputDecoration(labelText: 'Carpet Area'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Carpet Area';
                          }
                          final area = int.tryParse(value);
                          if (area == null || area < 0 || area > 10000) {
                            return 'Please enter a valid Carpet Area (up to 10,000 sqft)';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5),
                        ],
                      ),
                      TextFormField(
                        controller: widget.rentPerMonthController,
                        decoration: InputDecoration(labelText: 'Rent per Month'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Rent per Month';
                          }
                          final amount = int.tryParse(value);
                          if (amount == null || amount < 0 || amount > 1000000) {
                            return 'Please enter a valid Rent per Month (up to 1,000,000)';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(7),
                        ],
                      ),
                      TextFormField(
                        controller: widget.advanceRentController,
                        decoration: InputDecoration(labelText: 'Advance Rent'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Advance Rent';
                          }
                          final amount = int.tryParse(value);
                          if (amount == null || amount < 0 || amount > 1000000) {
                            return 'Please enter a valid Advance Rent (up to 1,000,000)';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(7),
                        ],
                      ),
                      TextFormField(
                        controller: widget.bedRoomsController,
                        decoration: InputDecoration(labelText: 'Bedrooms'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Bedrooms count';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                      ),
                      TextFormField(
                        controller: widget.bathRoomsController,
                        decoration: InputDecoration(labelText: 'Bathrooms'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Bathrooms count';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                      ),
                      TextFormField(
                        controller: widget.balConiesController,
                        decoration: InputDecoration(labelText: 'Balconies'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Balconies count';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
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
                                File(image.path),
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
            AmenitiesCard(
              onAmenitiesChanged: _handleAmenitiesChanged,
            ),
            ExtraAmenitiesCard(
              onExtraAmenitiesChanged: _handleExtraAmenitiesChanged,
            ),
            ElevatedButton(
              onPressed: _isSubmitting ? null : () => _savePropertyDetails(context),
              child: _isSubmitting ? CircularProgressIndicator() : Text('Add Property'),
            ),
          ],
        ),
      ),
    );
  }
}