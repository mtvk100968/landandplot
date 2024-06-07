import 'package:flutter/material.dart';
import '../services/address_service.dart';

class AddressCard extends StatefulWidget {
  final TextEditingController houseNoController;
  final TextEditingController colonyController;
  final TextEditingController tmcController;
  final TextEditingController cityController;
  final TextEditingController districtController;
  final TextEditingController stateController;
  final TextEditingController pincodeController;

  AddressCard({
    required this.houseNoController,
    required this.colonyController,
    required this.tmcController,
    required this.cityController,
    required this.districtController,
    required this.stateController,
    required this.pincodeController,
  });

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void _fetchAddressDetails() async {
    print("Fetching address details for pincode: ${widget.pincodeController.text}");
    try {
      final addressDetails = await AddressService.getAddressDetailsFromPincode(widget.pincodeController.text);
      if (addressDetails != null) {
        print("Address details fetched: $addressDetails");
        setState(() {
          widget.cityController.text = addressDetails['city'];
          widget.districtController.text = addressDetails['district'];
          widget.stateController.text = addressDetails['state'];
        });
      } else {
        print("No address details found");
      }
    } catch (error) {
      print("Error fetching address details: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(1.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Address of Property',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TextFormField(
                  controller: widget.pincodeController,
                  decoration: InputDecoration(labelText: 'Pin code'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.length == 6) {
                      _fetchAddressDetails();
                    }
                  },
                  onFieldSubmitted: (value) {
                    if (value.length == 6) {
                      _fetchAddressDetails();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a pin code';
                    } else if (value.length != 6) {
                      return 'Pin code must be exactly 6 digits';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: widget.houseNoController,
                  decoration: InputDecoration(labelText: 'House No'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a House No';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: widget.colonyController,
                  decoration: InputDecoration(labelText: 'Colony name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Colony name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: widget.tmcController,
                  decoration: InputDecoration(labelText: 'Tmc name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Tmc name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: widget.cityController,
                  decoration: InputDecoration(labelText: 'City name'),
                  enabled: false,
                ),
                TextFormField(
                  controller: widget.districtController,
                  decoration: InputDecoration(labelText: 'District name'),
                  enabled: false,
                ),
                TextFormField(
                  controller: widget.stateController,
                  decoration: InputDecoration(labelText: 'State name'),
                  enabled: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}