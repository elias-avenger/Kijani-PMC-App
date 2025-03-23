// lib/utilities/location.dart
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class Locator {
  // Check and request location permissions
  Future<bool> _checkAndRequestPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (kDebugMode) print('Location services are disabled');
      return false;
    }

    // Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (kDebugMode) print('Location permissions denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (kDebugMode) print('Location permissions permanently denied');
      return false;
    }

    return true;
  }

  // Get the current position of the device
  Future<Position?> getCurrentPosition() async {
    try {
      // Ensure permissions are granted
      bool hasPermission = await _checkAndRequestPermissions();
      if (!hasPermission) {
        return null;
      }

      // Fetch the current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
      );
      return position;
    } catch (e) {
      if (kDebugMode) print('Error getting location: $e');
      return null;
    }
  }
}
