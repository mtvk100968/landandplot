import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc; // Aliased location package
import 'package:permission_handler/permission_handler.dart';
import '../services/storage_service.dart';
import 'amenities_card.dart';
import 'extra_amenities_card.dart';
import 'location_card.dart';

class AgricultureLandCard extends StatefulWidget {
  final TextEditingController propertyIdController;
  final TextEditingController mobileNoController;
  final TextEditingController propertyOwnerNameController;
  final TextEditingController propertyRegByController;
  final TextEditingController pricePerAcreController;
  final TextEditingController totalAcresController;
  final TextEditingController totalLandPriceController;
  final TextEditingController roadAccessController;
  final TextEditingController roadInfeetsController;
  final TextEditingController landFaceingLengthController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final Map<String, dynamic> propertyDetails;
  final Function(Map<String, dynamic>) onSave;
  AgricultureLandCard({
    Key? key,
    required this.propertyIdController,
    required this.mobileNoController,
    required this.propertyOwnerNameController,
    required this.propertyRegByController,
    required this.pricePerAcreController,
    required this.totalAcresController,
    required this.totalLandPriceController,
    required this.roadAccessController,
    required this.roadInfeetsController,
    required this.landFaceingLengthController,
    required this.latitudeController,
    required this.longitudeController,
    required this.propertyDetails,
    required this.onSave,
  }) : super(key: key);

  @override
  _AgricultureLandCardState createState() => _AgricultureLandCardState();
}

class _AgricultureLandCardState extends State<AgricultureLandCard> {
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  late final Map<String, dynamic> propertyDetails;
  late final Function(Map<String, dynamic>) onSave;

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
    final loc.PermissionStatus locationPermission = await loc.Location().requestPermission(); // Aliased PermissionStatus

    if (photosPermission.isDenied || storagePermission.isDenied || cameraPermission.isDenied || locationPermission == loc.PermissionStatus.denied) {
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
        'ownerName': widget.propertyOwnerNameController.text,
        'regBy': widget.propertyRegByController.text,
        'pricePerAcre': int.parse(widget.pricePerAcreController.text),
        'totalAcres': int.parse(widget.totalAcresController.text),
        'totalLandPrice': int.parse(widget.totalLandPriceController.text),
        'roadAccess': widget.roadAccessController.text,
        'roadInFeets': int.parse(widget.roadInfeetsController.text),
        'landFaceingLength': int.parse(widget.landFaceingLengthController.text),
        'latitude': double.parse(_latController.text),
        'longitude': double.parse(_lngController.text),
        'imageUrls': imageUrls, // Store uploaded image URLs in Firestore
      }).then((value) {
        widget.propertyIdController.clear();
        widget.mobileNoController.clear();
        widget.propertyOwnerNameController.clear();
        widget.propertyRegByController.clear();
        widget.pricePerAcreController.clear();
        widget.totalAcresController.clear();
        widget.roadAccessController.clear();
        widget.roadInfeetsController.clear();
        widget.landFaceingLengthController.clear();
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
    'bore': false,
    'fenceing': false,
    'eletrcity': false,
    'gate': false,
    'farm house': false,
  };

  Map<String, bool> extraAmenities = {
    'plantation': false,
    'Swimming Pool': false,
    'no of trees': false,
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
                        controller: widget.propertyOwnerNameController,
                        decoration: InputDecoration(
                          labelText: 'Property Owner Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Property Owner Name';
                          }
                          return null;
                        },
                        maxLength: 100,
                        maxLines: null,
                      ),
                      TextFormField(
                        controller: widget.propertyRegByController,
                        decoration: InputDecoration(
                          labelText: 'Property Reg By',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Property Reg By Name';
                          }
                          return null;
                        },
                        maxLength: 100,
                        maxLines: null,
                      ),
                      TextFormField(
                        controller: widget.pricePerAcreController,
                        decoration: InputDecoration(labelText: 'Price per acre'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Price per acre';
                          }
                          final area = int.tryParse(value);
                          if (area == null || area < 0 || area > 99999999999) {
                            return 'Please enter a valid Price per acre (up to 99999999999)';
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
                        controller: widget.totalAcresController,
                        decoration: InputDecoration(labelText: 'Total Acres'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Total Acres';
                          }
                          final area = int.tryParse(value);
                          if (area == null || area < 0 || area > 10000) {
                            return 'Please enter a valid Total Acres (up to 5000)';
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
                        controller: widget.totalLandPriceController,
                        decoration: InputDecoration(labelText: 'Total Land Price'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Total Land Price';
                          }
                          final amount = int.tryParse(value);
                          if (amount == null || amount < 0 || amount > 1000000) {
                            return 'Please enter a valid Total Land Price (up to 1,000,000)';
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
                        controller: widget.roadAccessController,
                        decoration: InputDecoration(labelText: 'Road Access'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Road Access';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(20),
                        ],
                      ),
                      TextFormField(
                        controller: widget.roadInfeetsController,
                        decoration: InputDecoration(labelText: 'Road in Feets'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Road in Feets';
                          }
                          final amount = int.tryParse(value);
                          if (amount == null || amount < 0 || amount > 1000) {
                            return 'Please enter a valid Road in Feets (up to 1,000)';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                      ),
                      TextFormField(
                        controller: widget.landFaceingLengthController,
                        decoration: InputDecoration(labelText: 'Land Facing Length'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Land Facing Length';
                          }
                          final amount = int.tryParse(value);
                          if (amount == null || amount < 0 || amount > 1000) {
                            return 'Please enter a valid Land Facing Length (up to 1,000)';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
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
