// Step 1: Set Up the Form and State Management
// You’ll need a StatefulWidget to manage the form state and a corresponding model class to hold the form data.
//
// For simplicity, let's define a combined model to hold all form data, and later you can split it as needed when saving to Firebase:

// Step 2: Define the UI for Each Section
// Create a separate widget for each form section. Use TextFormField for text inputs, DropdownButtonFormField for dropdowns, and other appropriate widgets for different data types.
//
// Property Details Form Section

// Step 3: Implement Form Navigation and Submission
// Use a Stepper widget or a similar approach to navigate between different sections. On the final step, provide a button to submit the form:

// Step 4: Firebase Integration
// Each section’s data can be stored in separate collections in Firebase, linked by propertyId.
// Use Firebase Storage for uploading and managing image URLs.
// Step 5: User Feedback and Validation
// Provide validation feedback for each form field.
// Use progress indicators and confirmations upon successful submission.
// This form will allow users to enter detailed property information in an organized manner, enhancing the data quality and user experience of your Rentlo app.

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:landandplot/services/firestore_database_service.dart';
import '../models/agriculture_land_details.dart';
import '../models/apartment_details.dart';
import '../models/commercial_plot_details.dart';
import '../models/farm_land_details.dart';
import '../models/gated_community_apt_details.dart';
import '../models/gated_community_plot_details.dart';
import '../models/gated_community_villa_details.dart';
import '../models/open_plot_details.dart';
import '../models/property_address.dart';
import '../models/villa_details.dart';
import '../widgets/address_card.dart';
import '../widgets/agriculture_card.dart';
import '../widgets/amenities_card.dart';
import '../widgets/apartment_card.dart';
import '../widgets/commercialland_card.dart';
import '../widgets/extraamenities_card.dart';
import '../widgets/farmland_card.dart';
import '../widgets/gcapt_card.dart';
import '../widgets/gcplot_card.dart';
import '../widgets/gcvilla_card.dart';
import '../widgets/openplot_card.dart';
import '../widgets/villa_card.dart';
import 'dart:ui' show lerpDouble;

class PropertyReg extends StatefulWidget {
  @override
  _PropertyRegState createState() => _PropertyRegState();
}

class _PropertyRegState extends State<PropertyReg> {
  final List<DropdownMenuItem<String>> propertyTypeItems = [
    DropdownMenuItem(
        value: "Agriculture Land", child: Text("Agriculture Land")),
    DropdownMenuItem(value: "Farm Land", child: Text("Farm Land")),
    DropdownMenuItem(value: "Commercial Plot", child: Text("Commercial Plot")),
    DropdownMenuItem(value: "Open Plot", child: Text("Open Plot")),
    DropdownMenuItem(value: "Villa", child: Text("Villa")),
    DropdownMenuItem(value: "Apartment", child: Text("Apartment")),
    DropdownMenuItem(
        value: "Gated Community Apt", child: Text("Gated Community Apt")),
    DropdownMenuItem(
        value: "Gated Community Plot", child: Text("Gated Community Plot")),
    DropdownMenuItem(
        value: "Gated Community Villa", child: Text("Gated Community Villa")),
  ];

  bool shouldShowSubmitButton() {
    // Implement your logic to check if all required fields for the selected property type are filled in
    // For now, just checking if a property type is selected
    return selectedPropertyType != null;
  }

  final _dbService = FirestoreDatabaseService();
  String? selectedPropertyType;
  bool _isSubmitting = false;
// Assuming you have stored the latitude and longitude in state variables:
  double? _selectedLatitude;
  double? _selectedLongitude;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pricePerAcreController = TextEditingController();
  final TextEditingController _pricePerYardController = TextEditingController();
  final TextEditingController _pricePerSftController = TextEditingController();
  final TextEditingController _totalAcresController = TextEditingController();
  final TextEditingController _totalLandPriceController =
      TextEditingController();
  final TextEditingController _totalAreaInYardsController =
      TextEditingController();
  final TextEditingController _totalFLandPriceController =
      TextEditingController();
  final TextEditingController _totalCPlotPriceController =
      TextEditingController();
  final TextEditingController _villaAreaInYardsController =
      TextEditingController();
  final TextEditingController _aptAreaInSqftController =
      TextEditingController();
  final TextEditingController _villaPricePerSftController =
      TextEditingController();
  final TextEditingController _villaTotalAreaController =
      TextEditingController();
  final TextEditingController _villaCarpetAreaController =
      TextEditingController();
  final TextEditingController _villaBedRoomsController =
      TextEditingController();
  final TextEditingController _villaBathRoomsController =
      TextEditingController();

  final TextEditingController _villaBuildAreaInSqftController =
      TextEditingController();
  final TextEditingController _villaCarpetAreaInSqftController =
      TextEditingController();
  final TextEditingController _villaPriceController = TextEditingController();
  final TextEditingController _villaBedroomsController =
      TextEditingController();
  final TextEditingController _villaBathroomsController =
      TextEditingController();
  final TextEditingController _villaBalconiesController =
      TextEditingController();
  final TextEditingController _aptCarpetAreaController =
      TextEditingController();
  final TextEditingController _aptPricePerSftController =
      TextEditingController();
  final TextEditingController _aptTotalAreaController = TextEditingController();
  final TextEditingController _aptBedRoomsController = TextEditingController();
  final TextEditingController _aptBathRoomsController = TextEditingController();
  final TextEditingController _aptPriceController = TextEditingController();
  final TextEditingController _aptBedroomsController = TextEditingController();
  final TextEditingController _aptBathroomsController = TextEditingController();
  final TextEditingController _aptBalconiesController = TextEditingController();

  final TextEditingController _gcplotAreaController = TextEditingController();
  final TextEditingController _gcPlotPriceController = TextEditingController();
  final TextEditingController _areaInYardsController = TextEditingController();
  final TextEditingController _gcVillaCarpetAreaController =
      TextEditingController();
  final TextEditingController _gcVillaPriceController = TextEditingController();
  final TextEditingController _gcVillaBedroomsController =
      TextEditingController();
  final TextEditingController _gcVillaBathroomsController =
      TextEditingController();
  final TextEditingController _gcVillaBalconiesController =
      TextEditingController();
  final TextEditingController _gcAptAreaController = TextEditingController();
  final TextEditingController _gcAptCarpetAreaController =
      TextEditingController();
  final TextEditingController _gcAptPriceController = TextEditingController();
  final TextEditingController _gcAptBedroomsController =
      TextEditingController();
  final TextEditingController _gcAaptBathroomsController =
      TextEditingController();
  final TextEditingController _gcAptBalconiesController =
      TextEditingController();
  final TextEditingController _propertyNameController = TextEditingController();
  final _villagenameController = TextEditingController();
  final _colonyController = TextEditingController();
  final _cityController = TextEditingController();
  final _tmcController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  // Inside _AddPropertyByLapState
  final _propertyIdController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _userIdControllor = TextEditingController();
  final _agentIdControllor = TextEditingController();
  final _ownerIdControllor = TextEditingController();

  int selectedValue = 1;
  late CameraController _controller;
  List<CameraDescription> cameras = [];

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      await _controller.initialize();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    _propertyIdController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _userIdControllor.dispose();
    _agentIdControllor.dispose();
    _ownerIdControllor.dispose();
    super.dispose();
  }

  Future<int> fetchPropertyCount() async {
    // TODO: Fetch the current property count from Firestore
    // For example purposes, let's assume it returns 100.
    return 100;
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate() && selectedPropertyType != null) {
      setState(() {
        _isSubmitting = true;
      });

      // Fetch the latest count from Firestore or your local storage
      int currentCount = await fetchPropertyCount();

      // Generate the property ID
      String propertyId = generatePropertyId('ST', 'DIS', 'TMC', currentCount);

      Map<String, dynamic> propertyDetails =
          {}; // Define it here so it's accessible later.

      // Gather property details based on the selected property type
      switch (selectedPropertyType) {
        case "Agriculture Land":
          if (_selectedLatitude != null && _selectedLongitude != null) {
            AgricultureLandDetails agricultureLandDetails =
                AgricultureLandDetails(
              propertyId: propertyId,
              pricePerAcre: double.tryParse(_pricePerAcreController.text) ?? 0,
              totalAcres: double.tryParse(_totalAcresController.text) ?? 0,
              price: double.tryParse(_totalLandPriceController.text) ?? 0,
              village: _villagenameController.text,
              colony: _colonyController.text,
              tmc: _tmcController.text,
              city: _cityController.text,
              district: _districtController.text,
              state: _stateController.text,
              pincode: double.tryParse(_pincodeController.text) ?? 0,
            );
            await agricultureLandDetails.saveToFirestore();
          } else {
            // Handle the error state here. For example:
            print("Please select a location on the map.");
          }
          break;
        case "Farm Land":
          if (_selectedLatitude != null && _selectedLongitude != null) {
            FarmLandDetails farmLandDetails = FarmLandDetails(
              propertyId: propertyId,
              pricePerSqy: double.tryParse(_pricePerYardController.text) ?? 0,
              totalYards:
                  double.tryParse(_totalAreaInYardsController.text) ?? 0,
              price: double.tryParse(_totalFLandPriceController.text) ?? 0,
              village: _villagenameController.text,
              colony: _colonyController.text,
              tmc: _tmcController.text,
              city: _cityController.text,
              district: _districtController.text,
              state: _stateController.text,
              pincode: double.tryParse(_pincodeController.text) ?? 0,
            );
            await farmLandDetails.saveToFirestore();
          } else {
            // Handle the error state here. For example:
            print("Please select a location on the map.");
          }
          break;
        case "Commercial Plot":
          if (_selectedLatitude != null && _selectedLongitude != null) {
            CommercialPlotDetails commercialPlotDetails = CommercialPlotDetails(
              propertyId: propertyId,
              pricePerSqy: double.tryParse(_pricePerYardController.text) ?? 0,
              totalYards:
                  double.tryParse(_totalAreaInYardsController.text) ?? 0,
              price: double.tryParse(_totalFLandPriceController.text) ?? 0,
              village: _villagenameController.text,
              colony: _colonyController.text,
              tmc: _tmcController.text,
              city: _cityController.text,
              district: _districtController.text,
              state: _stateController.text,
              pincode: double.tryParse(_pincodeController.text) ?? 0,
              latitude: _selectedLatitude!, // No longer null
              longitude: _selectedLongitude!, // No longer null
            );
            await commercialPlotDetails.saveToFirestore();
          } else {
            // Handle the error state here. For example:
            print("Please select a location on the map.");
          }
          break;
        case "Open Plot":
          if (_selectedLatitude != null && _selectedLongitude != null) {
            OpenPlotDetails openPlotDetails = OpenPlotDetails(
              propertyId: propertyId,
              pricePerSqy: double.tryParse(_pricePerYardController.text) ?? 0,
              totalYards:
                  double.tryParse(_totalAreaInYardsController.text) ?? 0,
              price: double.tryParse(_totalFLandPriceController.text) ?? 0,
              village: _villagenameController.text,
              colony: _colonyController.text,
              tmc: _tmcController.text,
              city: _cityController.text,
              district: _districtController.text,
              state: _stateController.text,
              pincode: double.tryParse(_pincodeController.text) ?? 0,
            );
            await openPlotDetails.saveToFirestore();
          } else {
            // Handle the error state here. For example:
            print("Please select a location on the map.");
          }
          break;
        case "Villa":
          if (_selectedLatitude != null && _selectedLongitude != null) {
            VillaDetails villaDetails = VillaDetails(
              propertyId: propertyId,
              propertyName: double.tryParse(_propertyNameController.text) ?? 0,
              pricePerSft:
                  double.tryParse(_villaPricePerSftController.text) ?? 0,
              totalArea: double.tryParse(_villaTotalAreaController.text) ?? 0,
              carpetArea: double.tryParse(_villaCarpetAreaController.text) ?? 0,
              price: double.tryParse(_villaPriceController.text) ?? 0,
              bedRooms: double.tryParse(_villaBedRoomsController.text) ?? 0,
              bathRooms: double.tryParse(_villaBathRoomsController.text) ?? 0,
              balConies: double.tryParse(_villaBalconiesController.text) ?? 0,
              village: _villagenameController.text,
              colony: _colonyController.text,
              tmc: _tmcController.text,
              city: _cityController.text,
              district: _districtController.text,
              state: _stateController.text,
              pincode: double.tryParse(_pincodeController.text) ?? 0,
            );
            await villaDetails.saveToFirestore();
          } else {
            // Handle the error state here. For example:
            print("Please select a location on the map.");
          }
          break;
        case "Apartment":
          if (_selectedLatitude != null && _selectedLongitude != null) {
            Apartment_Details apartmentDetails = Apartment_Details(
              propertyId: propertyId,
              propertyName: double.tryParse(_propertyNameController.text) ?? 0,
              pricePerSft: double.tryParse(_aptPricePerSftController.text) ?? 0,
              totalArea: double.tryParse(_aptTotalAreaController.text) ?? 0,
              carpetArea: double.tryParse(_aptCarpetAreaController.text) ?? 0,
              price: double.tryParse(_aptPriceController.text) ?? 0,
              bedRooms: double.tryParse(_aptBedRoomsController.text) ?? 0,
              bathRooms: double.tryParse(_aptBathRoomsController.text) ?? 0,
              balConies: double.tryParse(_aptBalconiesController.text) ?? 0,
              village: _villagenameController.text,
              colony: _colonyController.text,
              tmc: _tmcController.text,
              city: _cityController.text,
              district: _districtController.text,
              state: _stateController.text,
              pincode: double.tryParse(_pincodeController.text) ?? 0,
            );
            await apartmentDetails.saveToFirestore();
          } else {
// Handle the error state here. For example:
            print("Please select a location on the map.");
          }
          break;
        case "Gated Community Plot":
          if (_selectedLatitude != null && _selectedLongitude != null) {
            GatedCommunityPlotDetails gatedCommunityPlotDetails =
                GatedCommunityPlotDetails(
              propertyId: propertyId,
              pricePerSqy: double.tryParse(_pricePerYardController.text) ?? 0,
              totalYards:
                  double.tryParse(_totalAreaInYardsController.text) ?? 0,
              price: double.tryParse(_totalFLandPriceController.text) ?? 0,
              village: _villagenameController.text,
              colony: _colonyController.text,
              tmc: _tmcController.text,
              city: _cityController.text,
              district: _districtController.text,
              state: _stateController.text,
              pincode: double.tryParse(_pincodeController.text) ?? 0,
            );
            await gatedCommunityPlotDetails.saveToFirestore();
          } else {
// Handle the error state here. For example:
            print("Please select a location on the map.");
          }
          break;
        case "Gated Community Villa":
          if (_selectedLatitude != null && _selectedLongitude != null) {
            GatedCommunityVillaDetails gatedCommunityVillaDetails =
                GatedCommunityVillaDetails(
              propertyId: propertyId,
              propertyName: double.tryParse(_propertyNameController.text) ?? 0,
              pricePerSft:
                  double.tryParse(_villaPricePerSftController.text) ?? 0,
              totalArea: double.tryParse(_villaTotalAreaController.text) ?? 0,
              carpetArea: double.tryParse(_villaCarpetAreaController.text) ?? 0,
              price: double.tryParse(_villaPriceController.text) ?? 0,
              bedRooms: double.tryParse(_villaBedRoomsController.text) ?? 0,
              bathRooms: double.tryParse(_villaBathRoomsController.text) ?? 0,
              balConies: double.tryParse(_villaBalconiesController.text) ?? 0,
              village: _villagenameController.text,
              colony: _colonyController.text,
              tmc: _tmcController.text,
              city: _cityController.text,
              district: _districtController.text,
              state: _stateController.text,
              pincode: double.tryParse(_pincodeController.text) ?? 0,
            );
            await gatedCommunityVillaDetails.saveToFirestore();
          } else {
// Handle the error state here. For example:
            print("Please select a location on the map.");
          }
          break;
        case "Gated Community Aprt":
          if (_selectedLatitude != null && _selectedLongitude != null) {
            GatedCommunityAptDetails gatedCommunityAptDetails =
                GatedCommunityAptDetails(
              propertyId: propertyId,
              propertyName: double.tryParse(_propertyNameController.text) ?? 0,
              pricePerSft: double.tryParse(_aptPricePerSftController.text) ?? 0,
              totalArea: double.tryParse(_aptTotalAreaController.text) ?? 0,
              carpetArea: double.tryParse(_aptCarpetAreaController.text) ?? 0,
              price: double.tryParse(_aptPriceController.text) ?? 0,
              bedRooms: double.tryParse(_aptBedRoomsController.text) ?? 0,
              bathRooms: double.tryParse(_aptBathRoomsController.text) ?? 0,
              balConies: double.tryParse(_aptBalconiesController.text) ?? 0,
              village: _villagenameController.text,
              colony: _colonyController.text,
              tmc: _tmcController.text,
              city: _cityController.text,
              district: _districtController.text,
              state: _stateController.text,
              pincode: double.tryParse(_pincodeController.text) ?? 0,
            );
            await gatedCommunityAptDetails.saveToFirestore();
          } else {
// Handle the error state here. For example:
            print("Please select a location on the map.");
          }
          break; // Add cases for other property types
      }
      // Now, `propertyDetails` is ready to be saved to Firestore
      // Since all property details are being sent to the same collection,
      // 'properties', you can call `addOrUpdateProperty` with `propertyDetails`.
      try {
        await _dbService.addOrUpdateProperty(propertyId, propertyDetails);
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
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // Make sure your FirestoreDatabaseService class has a method like this:
  Future<void> addOrUpdateProperty(
      String propertyId, Map<String, dynamic> propertyDetails) async {
    try {
      await _dbService.addOrUpdateProperty(propertyId, propertyDetails);
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
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  String generatePropertyId(
      String stateCode, String districtCode, String tmcCode, int count) {
    // Format the count to be a string with leading zeros, 10 digits long.
    String formattedCount = count.toString().padLeft(10, '0');
    return '$stateCode$districtCode$tmcCode$formattedCount';
  }

  // String generatePropertyId() {
  //   // Use timestamp or another unique value to generate the property ID
  //   return 'PROP_${DateTime.now().millisecondsSinceEpoch}';
  // }

  // String generatePropertyId(String? propertyType) {
  //   // Get the first 4 letters of the property type, defaulting to 'PROP' if not enough characters
  //   String typePrefix = (propertyType != null && propertyType.length >= 4)
  //       ? propertyType.substring(0, 4).toUpperCase()
  //       : 'PROP';
  //
  //   // Generate the property ID using the type prefix and a timestamp
  //   return '${typePrefix}_${DateTime.now().millisecondsSinceEpoch}';
  // }

  // TODO: Initialize your TextEditingControllers here
  @override
  Widget build(BuildContext context) {
    // Build a form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Property'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: selectedPropertyType,
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
              // Check the selected property type and display relevant cards
              if (selectedPropertyType == "Agriculture Land") ...[
                AgricultureCard(
                  pricePerAcreController: _pricePerAcreController,
                  totalAcresController: _totalAcresController,
                  totalLandPriceController: _totalLandPriceController,
                ),
                AddressCard(
                  villagenameController: _villagenameController,
                  colonyController: _colonyController,
                  tmcController: _tmcController,
                  cityController: _cityController,
                  districtController: _districtController,
                  stateController: _stateController,
                  pincodeController: _pincodeController,
                ),
              ] else if (selectedPropertyType == "Farm Land") ...[
                // Show the farm land specific card
                FarmLandCard(
                  pricePerYardController: _pricePerYardController,
                  totalAreaInYardsController: _totalAreaInYardsController,
                  totalFLandPriceController: _totalFLandPriceController,
                ),
                AddressCard(
                  villagenameController: _villagenameController,
                  colonyController: _colonyController,
                  tmcController: _tmcController,
                  cityController: _cityController,
                  districtController: _districtController,
                  stateController: _stateController,
                  pincodeController: _pincodeController,
                ),
              ] else if (selectedPropertyType == "Open Plot") ...[
                // Show the open plot specific card
                OpenPlotCard(
                  pricePerYardController: _pricePerYardController,
                  totalAreaInYardsController: _totalAreaInYardsController,
                  totalOLandPriceController: _totalLandPriceController,
                ),
                AddressCard(
                  villagenameController: _villagenameController,
                  colonyController: _colonyController,
                  tmcController: _tmcController,
                  cityController: _cityController,
                  districtController: _districtController,
                  stateController: _stateController,
                  pincodeController: _pincodeController,
                ),
              ] else if (selectedPropertyType == "Commercial Plot") ...[
                // Show the commercial plot specific card
                CommercialPlotCard(
                  pricePerYardController: _pricePerYardController,
                  totalAreaInYardsController: _totalAreaInYardsController,
                  totalCPlotPriceController: _totalCPlotPriceController,
                ),
                AddressCard(
                  villagenameController: _villagenameController,
                  colonyController: _colonyController,
                  tmcController: _tmcController,
                  cityController: _cityController,
                  districtController: _districtController,
                  stateController: _stateController,
                  pincodeController: _pincodeController,
                ),
              ] else if (selectedPropertyType == "Villa") ...[
                // Show the villa specific card
                VillaCard(
                  propertyNameController: _propertyNameController,
                  pricePerSftController: _pricePerSftController,
                  villaAreaInYardsController: _villaAreaInYardsController,
                  villaBuildAreaInSqftController:
                      _villaBuildAreaInSqftController,
                  villaCarpetAreaInSqftController:
                      _villaCarpetAreaInSqftController,
                  villaPriceController: _villaPriceController,
                  villaBedroomsController: _villaBedroomsController,
                  villaBathroomsController: _villaBathroomsController,
                  villaBalconiesController: _villaBalconiesController,
                ),
                AddressCard(
                  villagenameController: _villagenameController,
                  colonyController: _colonyController,
                  tmcController: _tmcController,
                  cityController: _cityController,
                  districtController: _districtController,
                  stateController: _stateController,
                  pincodeController: _pincodeController,
                ),
              ] else if (selectedPropertyType == "Apartment") ...[
                // Show the apartment specific card
                ApartmentCard(
                  propertyNameController: _propertyNameController,
                  pricePerSftController: _pricePerSftController,
                  aptAreaInSqftController: _aptAreaInSqftController,
                  aptCarpetAreaController: _aptCarpetAreaController,
                  aptPriceController: _aptPriceController,
                  aptBedroomsController: _aptBedroomsController,
                  aptBathroomsController: _aptBathroomsController,
                  aptBalconiesController: _aptBalconiesController,
                ),
                AddressCard(
                  villagenameController: _villagenameController,
                  colonyController: _colonyController,
                  tmcController: _tmcController,
                  cityController: _cityController,
                  districtController: _districtController,
                  stateController: _stateController,
                  pincodeController: _pincodeController,
                ),
              ] else if (selectedPropertyType == "Gated Community Apt") ...[
                GcAptCard(
                  propertyNameController: _propertyNameController,
                  pricePerSftController: _pricePerSftController,
                  gcAptAreaController: _gcAptAreaController,
                  gcAptCarpetAreaController: _gcAptCarpetAreaController,
                  gcAptPriceController: _gcAptPriceController,
                  gcAptBedroomsController: _gcAptBedroomsController,
                  gcAaptBathroomsController: _gcAaptBathroomsController,
                  gcAptBalconiesController: _gcAptBalconiesController,
                ),
                AddressCard(
                  villagenameController: _villagenameController,
                  colonyController: _colonyController,
                  tmcController: _tmcController,
                  cityController: _cityController,
                  districtController: _districtController,
                  stateController: _stateController,
                  pincodeController: _pincodeController,
                ),
              ] else if (selectedPropertyType == "Gated Community Plot") ...[
                GcPlotCard(
                  propertyNameController: _propertyNameController,
                  pricePerYardController: _pricePerYardController,
                  gcPlotAreaController: _gcplotAreaController,
                  gcPlotPriceController: _gcPlotPriceController,
                ),
                AddressCard(
                  villagenameController: _villagenameController,
                  colonyController: _colonyController,
                  tmcController: _tmcController,
                  cityController: _cityController,
                  districtController: _districtController,
                  stateController: _stateController,
                  pincodeController: _pincodeController,
                ),
              ] else if (selectedPropertyType == "Gated Community Villa") ...[
                GcVillaCard(
                  propertyNameController: _propertyNameController,
                  pricePerSftController: _pricePerSftController,
                  areaInYardsController: _areaInYardsController,
                  gcVillaCarpetAreaController: _gcVillaCarpetAreaController,
                  gcVillaPriceController: _gcVillaPriceController,
                  gcVillaBedroomsController: _gcVillaBedroomsController,
                  gcVillaBathroomsController: _gcVillaBathroomsController,
                  gcVillaBalconiesController: _gcVillaBalconiesController,
                ),
                AddressCard(
                  villagenameController: _villagenameController,
                  colonyController: _colonyController,
                  tmcController: _tmcController,
                  cityController: _cityController,
                  districtController: _districtController,
                  stateController: _stateController,
                  pincodeController: _pincodeController,
                ),
              ],

              // Conditional rendering for the 'Add Property' button
              if (shouldShowSubmitButton()) // You would replace this with your actual condition check
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  child: _isSubmitting
                      ? CircularProgressIndicator()
                      : Text('Add Property'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
