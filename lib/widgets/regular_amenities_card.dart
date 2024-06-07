// // amenities_card.dart
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class AminitiesCard extends StatelessWidget {
//   final TextEditingController internetController;
//   final TextEditingController cctvController;
//   final TextEditingController powerBackupController;
//   final TextEditingController fireExtinguishersController;
//   final TextEditingController carParkinController;
//   final TextEditingController gasPipelineController;
//   final TextEditingController intercomController;
//   final TextEditingController securityController;
//   final TextEditingController gymController;
//   // final TextEditingController dWasherController;
//   // final TextEditingController wachineController;
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//   AminitiesCard({
//     Key? key,
//     required this.internetController,
//     required this.cctvController,
//     required this.powerBackupController,
//     required this.fireExtinguishersController,
//     required this.carParkinController,
//     required this.gasPipelineController,
//     required this.intercomController,
//     required this.securityController,
//     required this.gymController,
//     // required this.dWasherController,
//     // required this.wachineController,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.only(bottom: 8.0),
//                   child: Text(
//                     'Address of Property',
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                 ),
//                 TextFormField(
//                   controller: internetController,
//                   decoration: InputDecoration(labelText: 'Village name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a Fans Count';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: cctvController,
//                   decoration: InputDecoration(labelText: 'Colony name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Geyser Count';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: powerBackupController,
//                   decoration: InputDecoration(labelText: 'Tmc name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter TVs Count';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: fireExtinguishersController,
//                   decoration: InputDecoration(labelText: 'City name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Dining Table';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: carParkinController,
//                   decoration: InputDecoration(labelText: 'District name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter District name';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: gasPipelineController,
//                   decoration: InputDecoration(labelText: 'State name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter State name';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: intercomController,
//                   decoration: InputDecoration(labelText: 'Pin code'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Pin code';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: securityController,
//                   decoration: InputDecoration(labelText: 'Pin code'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Pin code';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: gymController,
//                   decoration: InputDecoration(labelText: 'Pin code'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Pin code';
//                     }
//                     return null;
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegularAmenitiesCard extends StatefulWidget {
  final Function(Map<String, bool>) onAmenitiesChanged;

  RegularAmenitiesCard({Key? key, required this.onAmenitiesChanged}) : super(key: key);

  @override
  _RegularAmenitiesCardState createState() => _RegularAmenitiesCardState();
}

class _RegularAmenitiesCardState extends State<RegularAmenitiesCard> {
  Map<String, bool> amenities = {
    'Ghmc Water': false,
    'Lift': false,
    'Power Backup': false,
    'Bike Parking': false,
    'Car Parking': false,

  };

  void _handleAmenityChange(String amenity, bool value) {
    setState(() {
      amenities[amenity] = value;
      widget.onAmenitiesChanged(amenities);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Regular Amenities',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ...amenities.keys.map((String key) {
                  return SwitchListTile(
                    title: Text(key),
                    value: amenities[key]!,
                    onChanged: (bool value) => _handleAmenityChange(key, value),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}