// gcapt_card.dart
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'amenities_card.dart';
import 'extra_amenities_card.dart';
import 'location_card.dart';

class GcAptCard extends StatefulWidget {
  final TextEditingController propertyIdController;
  final TextEditingController mobileNoController;
  final TextEditingController propertyNameController;
  final TextEditingController ratePerSftController;
  final TextEditingController totalAreaController;
  final TextEditingController aminitiesChargesController;
  final TextEditingController carpetAreaController;
  final TextEditingController bedRoomsController;
  final TextEditingController bathRoomsController;
  final TextEditingController balConiesController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final Map<String, dynamic> propertyDetails;
  final Function(Map<String, dynamic>) onSave;
  GcAptCard({
    Key? key,
    required this.propertyIdController,
    required this.mobileNoController,
    required this.propertyNameController,
    required this.ratePerSftController,
    required this.totalAreaController,
    required this.aminitiesChargesController,
    required this.carpetAreaController,
    required this.bedRoomsController,
    required this.bathRoomsController,
    required this.balConiesController,
    required this.latitudeController,
    required this.longitudeController,
    required this.propertyDetails,
    required this.onSave,
  }) : super(key: key);

  @override
  _GcAptCardState createState() => _GcAptCardState();
}

class _GcAptCardState extends State<GcAptCard> {
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
                      decoration: InputDecoration(labelText: 'Property ID'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Property ID';
                        }
                        return null;
                      },
                    ),
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
                      controller: widget.ratePerSftController,
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
                      controller: widget.totalAreaController,
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
                      controller: widget.aminitiesChargesController,
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
              height: 400,
              width: MediaQuery.of(context).size.width,
              latitudeController: _latController,
              longitudeController: _lngController,
            ),
          ),
          AmenitiesCard(
            onAmenitiesChanged: _handleAmenitiesChanged,
          ),
          ExtraAmenitiesCard(
            onExtraAmenitiesChanged: _handleExtraAmenitiesChanged,
          ),

        ],
      ),
    );
  }
}