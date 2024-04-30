import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  final loc.Location _location = loc.Location();

  Future<void> requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print("Location permission granted");
    } else if (status.isDenied) {
      print("Location permission denied");
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // This method ensures that the app has permission to access the location
  Future<bool> ensureLocationPermission() async {
    bool _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return false; // Location services are not enabled
      }
    }

    loc.PermissionStatus _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return false; // Location permissions are denied
      }
    }
    return true; // Permissions are granted
  }

  // This method gets the current location of the user
  Future<loc.LocationData?> getCurrentLocation() async {
    bool hasPermission = await ensureLocationPermission();
    if (!hasPermission) {
      // Permissions are not granted
      return null;
    }
    return await _location.getLocation();
  }
}