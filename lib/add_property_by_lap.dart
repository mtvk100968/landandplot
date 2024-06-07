import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:landandplot/screens/property_image_screen.dart';
import 'package:landandplot/services/firestore_database_service.dart';
import 'package:landandplot/services/property_images.dart';
import 'package:landandplot/services/storage_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/property_service.dart';
import 'models/property_info.dart';

class AddPropertyByLap extends StatefulWidget {
  const AddPropertyByLap({Key? key}) : super(key: key);

  @override
  _AddPropertyByLapState createState() => _AddPropertyByLapState();
}

class _AddPropertyByLapState extends State<AddPropertyByLap> {
  final List<DropdownMenuItem<String>> propertyTypeItems = [
    const DropdownMenuItem(value: "Agriculture Land", child: Text("Agriculture Land")),
    const DropdownMenuItem(value: "Farm Land", child: Text("Farm Land")),
    const DropdownMenuItem(value: "Commercial Plot", child: Text("Commercial Plot")),
    const DropdownMenuItem(value: "Commercial Space", child: Text("Commercial Space")),
    const DropdownMenuItem(value: "House", child: Text("House")),
    const DropdownMenuItem(value: "Open Plot", child: Text("Open Plot")),
    const DropdownMenuItem(value: "Villa", child: Text("Villa")),
    const DropdownMenuItem(value: "Apartment", child: Text("Apartment")),
    const DropdownMenuItem(value: "Gated Community Aprts", child: Text("Gated Community Aprt")),
    const DropdownMenuItem(value: "Gated Community Plots", child: Text("Gated Community Aprt")),
    const DropdownMenuItem(value: "Gated Community Villa", child: Text("Gated Community Villa")),
  ];

  String? selectedPropertyType;
  final _formKey = GlobalKey<FormState>();
  final _propertyIdController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _priceController = TextEditingController();
  final _userIdController = TextEditingController();
  final _dbService = FirestoreDatabaseService();
  final StorageService _storageService = StorageService();
  final PropertyService _propertyService = PropertyService();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFileList = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  void dispose() {
    _propertyIdController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _priceController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  Future<void> requestPermissions() async {
    if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }
  }

  Future<void> _pickImages() async {
    await requestPermissions();

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

  Future<User?> signInAnonymously() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
        return userCredential.user;
      }
      return user;
    } catch (e) {
      print('Failed to sign in anonymously: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to authenticate: $e')),
      );
      return null;
    }
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate() || selectedPropertyType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please ensure all fields are filled correctly')),
      );
      return;
    }

    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    double? latitude = double.tryParse(_latController.text);
    double? longitude = double.tryParse(_lngController.text);

    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid latitude and longitude')),
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    double? price;
    try {
      String formattedPrice = _priceController.text.replaceAll(RegExp(r'[^0-9.]'), '');
      price = double.tryParse(formattedPrice);
      if (price == null) throw FormatException('Invalid price format');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error parsing price: $e')),
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    try {
      User? user = await signInAnonymously();
      if (user == null) {
        throw FirebaseAuthException(code: 'auth-failed', message: 'Authentication failed');
      }

      var newProperty = PropertyInfo(
        propertyId: _propertyIdController.text,
        propertyType: selectedPropertyType!, // Use the null-check operator
        latitude: latitude,
        longitude: longitude,
        iconPath: '',
        price: price,
        userId: _userIdController.text,
        imageUrls: [],
      );

      // Upload images and get their URLs
      List<String> imageUrls = await _propertyService.addPropertyWithImages(newProperty, _imageFileList);
      newProperty = newProperty.copyWith(imageUrls: imageUrls);

      await _addPropertyToDatabase(newProperty);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Property added successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add property: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _addPropertyToDatabase(PropertyInfo property) async {
    try {
      Map<String, dynamic> propertyMap = property.toMap();
      await _dbService.addOrUpdateProperty(property.propertyId, propertyMap, property.propertyType!);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Property added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add property: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Property'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _propertyIdController,
                decoration: InputDecoration(
                  labelText: 'Property ID',
                  hintText: "Enter or paste the property ID here",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a property ID';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedPropertyType,
                hint: Text("Select a Property type to add"),
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
                  double? val = double.tryParse(value);
                  if (val == null || val < -90 || val > 90) {
                    return 'Please enter a valid latitude (-90 to 90)';
                  }
                  return null;
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d{0,6}')),
                ],
              ),
              TextFormField(
                controller: _lngController,
                decoration: InputDecoration(labelText: 'Longitude'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter longitude';
                  }
                  double? val = double.tryParse(value);
                  if (val == null || val < -180 || val > 180) {
                    return 'Please enter a valid longitude (-180 to 180)';
                  }
                  return null;
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d{0,6}')),
                ],
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Property Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Property Price';
                  }
                  final amount = int.tryParse(value);
                  if (amount == null || amount < 0 || amount > 10000000000) {
                    return 'Please enter Property Price (up to 1,000,000000)';
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
                controller: _userIdController,
                decoration: InputDecoration(labelText: 'UserId'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the userId';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text('Pick Images'),
              ),
              if (_imageFileList.isNotEmpty)
                PropertyImages(
                  imageUrls: _imageFileList.map((xFile) => xFile.path).toList(),
                ),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                child: _isSubmitting ? CircularProgressIndicator() : Text('Add Property'),
              ),
              if (_imageFileList.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyImagesScreen(
                          imageUrls: _imageFileList.map((xFile) => xFile.path).toList(),
                        ),
                      ),
                    );
                  },
                  child: Text('View Selected Images'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}