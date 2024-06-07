import 'package:flutter/material.dart';
import 'package:landandplot/screens/billing_page.dart';
import 'package:landandplot/services/firestore_database_service.dart';
import 'package:landandplot/widgets/widgettype/apartment_card.dart';
import 'package:landandplot/widgets/widgettype/commercial_plot_card.dart';
import 'package:landandplot/widgets/widgettype/gcapt_card.dart';
import 'package:landandplot/widgets/widgettype/gcvilla_card.dart';
import 'package:landandplot/widgets/widgettype/house_card.dart';
import 'package:landandplot/widgets/widgettype/villa_card.dart';

class PropertyRegByUser extends StatefulWidget {
  @override
  _PropertyRegByUserState createState() => _PropertyRegByUserState();
}

class _PropertyRegByUserState extends State<PropertyRegByUser> {
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();

  final List<DropdownMenuItem<String>> propertyTypeItems = [
    const DropdownMenuItem(value: "Apartment", child: Text("Apartment")),
    const DropdownMenuItem(value: "House", child: Text("House")),
    const DropdownMenuItem(
        value: "Commercial Space", child: Text("Commercial Space")),
    const DropdownMenuItem(value: "Villa", child: Text("Villa")),
    const DropdownMenuItem(
        value: "Gated Community Apt", child: Text("Gated Community Apt")),
    const DropdownMenuItem(
        value: "Gated Community Villa", child: Text("Gated Community Villa")),
  ];
  bool _isMapVisible = true; // Default value, adjust based on your needs

  String? selectedPropertyType;
  bool _isSubmitting = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController propertyIdController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController propertyNameController = TextEditingController();
  final TextEditingController rentPerMonthController = TextEditingController();
  final TextEditingController areaInSqftController = TextEditingController();
  final TextEditingController carpetAreaController = TextEditingController();
  final TextEditingController advanceRentController = TextEditingController();
  final TextEditingController bedRoomsController = TextEditingController();
  final TextEditingController bathRoomsController = TextEditingController();
  final TextEditingController balConiesController = TextEditingController();
  final TextEditingController shatterLengthController = TextEditingController();
  final TextEditingController propertyOwnerNameController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  void _handleSave(Map<String, dynamic> propertyDetails) async {
    setState(() {
      _isSubmitting = true;
    });

    String stateCode = 'ST'; // Example: 'AP'
    String districtCode = 'DS'; // Example: 'HY'
    String mandalCode = 'MAN'; // Example: 'KUK'
    String propertyId =
        '${selectedPropertyType!.substring(0, 3).toUpperCase()}$stateCode$districtCode$mandalCode${DateTime.now().millisecondsSinceEpoch}';

    try {
      String propertyType = selectedPropertyType!.replaceAll(' ', '');
      await _dbService.addOrUpdateProperty(
          propertyId, propertyDetails, propertyType);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Property added successfully')));

      // Navigate to billing page after successful property registration
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BillingPage(
            propertyDetails: propertyDetails,
            onComplete: _handleBillingComplete,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add property: $e')));
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _handleBillingComplete(Map<String, dynamic> propertyDetails) async {
    // Send confirmation SMS and email notifications
    await sendConfirmationSMS(
        propertyDetails['mobileNo'], propertyDetails['propertyId']);
    await sendConfirmationEmail(propertyDetails);
    Navigator.pop(context);
  }

  Future<void> sendConfirmationSMS(String mobileNo, String propertyId) async {
    // Implement your SMS sending logic here using a service like Twilio
  }

  Future<void> sendConfirmationEmail(
      Map<String, dynamic> propertyDetails) async {
    // Implement your email sending logic here using a service like SendGrid
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
             Text(
              'LANDANDPLOT',
              style: TextStyle(
                color: Colors.green,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
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
              if (selectedPropertyType == "Apartment")
                ApartmentCard(
                  propertyIdController: propertyIdController,
                  mobileNoController: mobileNoController,
                  propertyNameController: propertyNameController,
                  rentPerMonthController: rentPerMonthController,
                  areaInSqftController: areaInSqftController,
                  carpetAreaController: carpetAreaController,
                  advanceRentController: advanceRentController,
                  bedRoomsController: bedRoomsController,
                  bathRoomsController: bathRoomsController,
                  balConiesController: balConiesController,
                  propertyDetails: {},
                  onSave: _handleSave,
                ),
              if (selectedPropertyType == "House")
                HouseCard(
                  propertyIdController: propertyIdController,
                  mobileNoController: mobileNoController,
                  propertyOwnerNameController: propertyNameController,
                  rentPerMonthController: rentPerMonthController,
                  areaInSqftController: areaInSqftController,
                  carpetAreaController: carpetAreaController,
                  advanceRentController: advanceRentController,
                  bedRoomsController: bedRoomsController,
                  bathRoomsController: bathRoomsController,
                  balConiesController: balConiesController,
                  propertyDetails: {},
                  onSave: _handleSave,
                ),
              if (selectedPropertyType == "Commercial Space")
                CommercialSpaceCard(
                  propertyIdController: propertyIdController,
                  mobileNoController: mobileNoController,
                  propertyNameController: propertyNameController,
                  propertyOwnerNameController: propertyOwnerNameController,
                  rentPerMonthController: rentPerMonthController,
                  advanceRentController: advanceRentController,
                  areaInSqftController: areaInSqftController,
                  carpetAreaController: carpetAreaController,
                  shatterLengthController: shatterLengthController,
                  propertyDetails: {},
                  onSave: _handleSave,
                  latitudeController: latitudeController,
                  longitudeController: longitudeController,
                ),
              if (selectedPropertyType == "Villa")
                VillaCard(
                  propertyIdController: propertyIdController,
                  mobileNoController: mobileNoController,
                  propertyNameController: propertyNameController,
                  rentPerMonthController: rentPerMonthController,
                  areaInSqftController: areaInSqftController,
                  carpetAreaController: carpetAreaController,
                  advanceRentController: advanceRentController,
                  bedRoomsController: bedRoomsController,
                  bathRoomsController: bathRoomsController,
                  balConiesController: balConiesController,
                  propertyDetails: {},
                  onSave: _handleSave,
                ),
              if (selectedPropertyType == "Gated Community Apt")
                GcAptCard(
                  propertyIdController: propertyIdController,
                  mobileNoController: mobileNoController,
                  propertyNameController: propertyNameController,
                  rentPerMonthController: rentPerMonthController,
                  areaInSqftController: areaInSqftController,
                  carpetAreaController: carpetAreaController,
                  advanceRentController: advanceRentController,
                  bedRoomsController: bedRoomsController,
                  bathRoomsController: bathRoomsController,
                  balConiesController: balConiesController,
                  propertyDetails: {},
                  onSave: _handleSave,
                ),
              if (selectedPropertyType == "Gated Community Villa")
                GcVillaCard(
                  propertyIdController: propertyIdController,
                  mobileNoController: mobileNoController,
                  propertyNameController: propertyNameController,
                  rentPerMonthController: rentPerMonthController,
                  areaInSqftController: areaInSqftController,
                  carpetAreaController: carpetAreaController,
                  advanceRentController: advanceRentController,
                  bedRoomsController: bedRoomsController,
                  bathRoomsController: bathRoomsController,
                  balConiesController: balConiesController,
                  propertyDetails: {},
                  onSave: _handleSave,
                ),
            ],
          ),
        ),
      ),
    );
  }
}