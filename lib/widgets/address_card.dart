import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final TextEditingController villagenameController;
  final TextEditingController colonyController;
  final TextEditingController tmcController;
  final TextEditingController cityController;
  final TextEditingController districtController;
  final TextEditingController stateController;
  final TextEditingController pincodeController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AddressCard({
    Key? key,
    required this.villagenameController,
    required this.colonyController,
    required this.tmcController,
    required this.cityController,
    required this.districtController,
    required this.stateController,
    required this.pincodeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
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
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                TextFormField(
                  controller: villagenameController,
                  decoration: InputDecoration(labelText: 'Village name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Village name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: colonyController,
                  decoration: InputDecoration(labelText: 'Colony name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Colony name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: tmcController,
                  decoration: InputDecoration(labelText: 'Tmc name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Tmc name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(labelText: 'City name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter City name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: districtController,
                  decoration: InputDecoration(labelText: 'District name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter District name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: stateController,
                  decoration: InputDecoration(labelText: 'State name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter State name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: pincodeController,
                  decoration: InputDecoration(labelText: 'Pin code'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Pin code';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
