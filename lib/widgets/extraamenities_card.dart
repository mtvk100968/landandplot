// // extraamenities_card.dart
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class ExtraAminitiesCard extends StatelessWidget {
//   final TextEditingController clubHouseaController;
//   final TextEditingController childrenParkController;
//   final TextEditingController walkingPathController;
//   final TextEditingController joggingParkController;
//   final TextEditingController spaController;
//   final TextEditingController swimmingPoolController;
//   final TextEditingController indoreGamesController;
//   final TextEditingController groceryShopController;
//   final TextEditingController sportsGroundController;
//   final TextEditingController yogaCenterController;
//   final TextEditingController shuttleCourtController;
//   final TextEditingController playSchoolController;
//   final TextEditingController shuttleController;
//   final TextEditingController fireSensorController;
//
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//   ExtraAminitiesCard({
//     Key? key,
//     required this.clubHouseaController,
//     required this.childrenParkController,
//     required this.walkingPathController,
//     required this.joggingParkController,
//     required this.spaController,
//     required this.swimmingPoolController,
//     required this.indoreGamesController,
//     required this.groceryShopController,
//     required this.sportsGroundController,
//     required this.yogaCenterController,
//     required this.shuttleCourtController,
//     required this.playSchoolController,
//     required this.shuttleController,
//     required this.fireSensorController,
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
//                   controller: clubHouseaController,
//                   decoration: InputDecoration(labelText: 'Village name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a Fans Count';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: childrenParkController,
//                   decoration: InputDecoration(labelText: 'Colony name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Geyser Count';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: walkingPathController,
//                   decoration: InputDecoration(labelText: 'Tmc name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter TVs Count';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: joggingParkController,
//                   decoration: InputDecoration(labelText: 'City name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Dining Table';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: spaController,
//                   decoration: InputDecoration(labelText: 'District name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter District name';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: swimmingPoolController,
//                   decoration: InputDecoration(labelText: 'State name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter State name';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: indoreGamesController,
//                   decoration: InputDecoration(labelText: 'Pin code'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Pin code';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: groceryShopController,
//                   decoration: InputDecoration(labelText: 'Pin code'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Pin code';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: sportsGroundController,
//                   decoration: InputDecoration(labelText: 'Pin code'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Pin code';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: yogaCenterController,
//                   decoration: InputDecoration(labelText: 'Pin code'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Pin code';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: shuttleCourtController,
//                   decoration: InputDecoration(labelText: 'Pin code'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Pin code';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: shuttleController,
//                   decoration: InputDecoration(labelText: 'Pin code'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Pin code';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: fireSensorController,
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

class ExtraAmenitiesCard extends StatefulWidget {
  final Function(Map<String, bool>) onExtraAmenitiesChanged;

  ExtraAmenitiesCard({Key? key, required this.onExtraAmenitiesChanged}) : super(key: key);

  @override
  _ExtraAmenitiesCardState createState() => _ExtraAmenitiesCardState();
}

class _ExtraAmenitiesCardState extends State<ExtraAmenitiesCard> {
  Map<String, bool> amenities = {
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

  void _handleExtraAmenityChange(String amenity, bool value) {
    setState(() {
      amenities[amenity] = value;
      widget.onExtraAmenitiesChanged(amenities);
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
                    'Extra Amenities',
                    style: Theme.of(context).textTheme.titleLarge,  // Updated to use titleLarge
                  ),
                ),
                ...amenities.keys.map((String key) {
                  return SwitchListTile(
                    title: Text(key),
                    value: amenities[key]!,
                    onChanged: (bool value) => _handleExtraAmenityChange(key, value),
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
