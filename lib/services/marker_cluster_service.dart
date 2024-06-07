import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/cluster_item.dart';
import '../models/property_info.dart';
import 'firestore_database_service.dart';

class MarkerClusterService {
  final FirestoreDatabaseService _firestoreDatabaseService;
  final double someClusterThreshold = 12.0;
  Set<Marker> _markers = <Marker>{};
  Set<Marker> _clusteredMarkers = <Marker>{};
  double _currentZoom = 15.0;
  Map<int, BitmapDescriptor> _clusterIcons = {};

  MarkerClusterService(this._firestoreDatabaseService);

  void setMarkers(Set<Marker> markers) {
    _markers = markers;
    _updateClusters();
  }

  void onCameraMove(CameraPosition position) {
    _currentZoom = position.zoom;
    _updateClusters();
  }

  Set<Marker> getCurrentClusters() {
    if (_currentZoom > someClusterThreshold) {
      return _markers;
    } else {
      return _clusteredMarkers;
    }
  }

  void updateClusters() {
    _updateClusters();
  }

  Future<BitmapDescriptor> generateIcon(int clusterSize) async {
    return BitmapDescriptor.defaultMarker;
  }

  Set<Marker> _convertFirestoreDataToMarkers(List<PropertyInfo> firestoreData) {
    Set<Marker> markers = {};
    for (var property in firestoreData) {
      markers.add(
        Marker(
          markerId: MarkerId(property.propertyId),
          position: LatLng(property.latitude, property.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            snippet: 'ID: ${property.propertyId}',
          ),
        ),
      );
    }
    return markers;
  }

  Future<BitmapDescriptor> _createCustomClusterIcon(int clusterSize) async {
    if (_clusterIcons.containsKey(clusterSize)) {
      return _clusterIcons[clusterSize]!;
    }
    BitmapDescriptor icon = await generateIcon(clusterSize);
    _clusterIcons[clusterSize] = icon;
    return icon;
  }

  void _updateClusters() {
    _clusteredMarkers.addAll(_markers);
  }

  Set<Marker> get clusteredMarkers => _clusteredMarkers;

  Future<void> loadMarkersFromFirestore() async {
    var firestoreData = await _firestoreDatabaseService.fetchPropertiesByType('somePropertyType');
    Set<Marker> markers = _convertFirestoreDataToMarkers(firestoreData);
    setMarkers(markers);
    updateClusters();
  }

  Future<List<ClusterItem>> getClusterItems() async {
    return await _firestoreDatabaseService.getClusterItems();
  }
}