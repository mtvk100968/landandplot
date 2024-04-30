// // marker_data.dart
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MarkerData {
//   final String propertyId;
//   final double latitude;
//   final double longitude;
//
//   MarkerData({
//     required this.propertyId,
//     required this.latitude,
//     required this.longitude,
//   });
// }
//
// List<MarkerData> listMarkers(void Function(String) onTap) {
//   List<MarkerData> MarkerDataList = [
//     MarkerData(
//       propertyId: '1',
//       latitude: 17.070222,
//       longitude: 78.196167,
//     ),
//
//     MarkerData(
//       propertyId: '2',
//       latitude: 17.437988,
//       longitude: 78.373893,
//     ),
//     MarkerData(
//       propertyId: '3',
//       latitude: 17.024201,
//       longitude: 78.217112,
//     ),
//     MarkerData(
//       propertyId: '4',
//       latitude: 17.072443,
//       longitude: 78.166646,
//     ),
//     MarkerData(
//       propertyId: '5',
//       latitude: 17.073698,
//       longitude: 78.151284,
//     ),
//     MarkerData(
//       propertyId: '6',
//       latitude: 17.073712,
//       longitude: 78.151387,
//     ),
//     MarkerData(
//       propertyId: '7',
//       latitude: 17.071343,
//       longitude: 78.142960,
//     ),
//     MarkerData(
//       propertyId: '8',
//       latitude: 17.073698,
//       longitude: 78.151284,
//     ),
//     MarkerData(
//       propertyId: '9',
//       latitude: 17.071723,
//       longitude: 78.144188,
//     ),
//     MarkerData(
//       propertyId: '10',
//       latitude: 17.437988,
//       longitude: 78.373893,
//     ),
//     MarkerData(
//       propertyId: '11',
//       latitude: 17.070142,
//       longitude: 78.196137,
//     ),
//     MarkerData(
//       propertyId: '12',
//       latitude: 17.039022,
//       longitude: 78.237900,
//     ),
//     MarkerData(
//       propertyId: '13',
//       latitude: 17.069619,
//       longitude: 78.196119,
//     ),
//     MarkerData(
//       propertyId: '14',
//       latitude: 17.069619,
//       longitude: 78.196119,
//     ),
//     MarkerData(
//       propertyId: '15',
//       latitude: 17.069390,
//       longitude: 78.196091,
//     ),
//     MarkerData(
//       propertyId: '16',
//       latitude: 17.071784,
//       longitude: 78.144191,
//     ),
//     MarkerData(
//       propertyId: '17',
//       latitude: 17.070385,
//       longitude: 78.196547,
//     ),
//     MarkerData(
//       propertyId: '18',
//       latitude: 17.069908,
//       longitude: 78.196134,
//     ),
//     MarkerData(
//       propertyId: '19',
//       latitude: 17.069898,
//       longitude: 78.195707,
//     ),
//     MarkerData(
//       propertyId: '20',
//       latitude: 17.163584,
//       longitude: 78.377753,
//     ),
//   ];
//
//   List<MarkerData> Property = [];
//
//   // for (var MarkerData in MarkerDataList) {
//   //   Property.add(
//   //     MarkerData(
//   //       MarkerDataId: MarkerDataId(MarkerData.propertyId),
//   //       position: LatLng(MarkerData.latitude, MarkerData.longitude),
//   //       infoWindow: InfoWindow(title: 'Property ${MarkerData.propertyId}'),
//   //       onTap: () => onTap(MarkerData.propertyId), // Pass propertyId to onTap
//   //     ),
//   //   );
//   // }
//   return Property;
//   // return listMarkers.map((markerData) {
//   //   return Marker(
//   //     markerId: MarkerId(markerData.propertyId),
//   //     position: LatLng(markerData.latitude, markerData.longitude),
//   //     onTap: () => onTap(markerData.propertyId),
//   //     // Add other properties to Marker if needed
//   //   );
//   // }).toList();
// }

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerData {
  final String propertyId;
  final double latitude;
  final double longitude;

  MarkerData({
    required this.propertyId,
    required this.latitude,
    required this.longitude,
  });
}

List<Marker> listMarkers(void Function(String) onTap) {
  List<MarkerData> markerDataList = [
    MarkerData(
      propertyId: '1',
      latitude: 17.070222,
      longitude: 78.196167,
    ),
    MarkerData(
      propertyId: '2',
      latitude: 17.437988,
      longitude: 78.373893,
    ),
    MarkerData(
      propertyId: '21',
      latitude: 17.437990,
      longitude: 78.373809,
    ),
    MarkerData(
      propertyId: '3',
      latitude: 17.024201,
      longitude: 78.217112,
    ),
    MarkerData(
      propertyId: '4',
      latitude: 17.072443,
      longitude: 78.166646,
    ),
    MarkerData(
      propertyId: '5',
      latitude: 17.073698,
      longitude: 78.151284,
    ),
    MarkerData(
      propertyId: '6',
      latitude: 17.073712,
      longitude: 78.151387,
    ),
    MarkerData(
      propertyId: '7',
      latitude: 17.071343,
      longitude: 78.142960,
    ),
    MarkerData(
      propertyId: '8',
      latitude: 17.073698,
      longitude: 78.151284,
    ),
    MarkerData(
      propertyId: '9',
      latitude: 17.071723,
      longitude: 78.144188,
    ),
    MarkerData(
      propertyId: '10',
      latitude: 17.437988,
      longitude: 78.373893,
    ),
    MarkerData(
      propertyId: '11',
      latitude: 17.070142,
      longitude: 78.196137,
    ),
    MarkerData(
      propertyId: '12',
      latitude: 17.039022,
      longitude: 78.237900,
    ),
    MarkerData(
      propertyId: '13',
      latitude: 17.069619,
      longitude: 78.196119,
    ),
    MarkerData(
      propertyId: '14',
      latitude: 17.069619,
      longitude: 78.196119,
    ),
    MarkerData(
      propertyId: '15',
      latitude: 17.069390,
      longitude: 78.196091,
    ),
    MarkerData(
      propertyId: '16',
      latitude: 17.071784,
      longitude: 78.144191,
    ),
    MarkerData(
      propertyId: '17',
      latitude: 17.070385,
      longitude: 78.196547,
    ),
    MarkerData(
      propertyId: '18',
      latitude: 17.069908,
      longitude: 78.196134,
    ),
    MarkerData(
      propertyId: '19',
      latitude: 17.069898,
      longitude: 78.195707,
    ),
    MarkerData(
      propertyId: '20',
      latitude: 17.163584,
      longitude: 78.377753,
    ),
  ];

  List<Marker> markers = [];

  for (var markerData in markerDataList) {
    markers.add(
      Marker(
        markerId: MarkerId(markerData.propertyId),
        position: LatLng(markerData.latitude, markerData.longitude),
        infoWindow: InfoWindow(title: 'Property ${markerData.propertyId}'),
        onTap: () => onTap(markerData.propertyId), // Pass propertyId to onTap
      ),
    );
  }
  return markers;
}
