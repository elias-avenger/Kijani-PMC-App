// lib/utilities/exif_utils.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:native_exif/native_exif.dart';
import 'package:path_provider/path_provider.dart';

class ExifUtils {
  static Future<bool> checkIfImageHasLocation(String imagePath) async {
    try {
      Exif exif = await Exif.fromPath(imagePath);
      ExifLatLong? latLong = await exif.getLatLong();
      await exif.close();
      return latLong != null;
    } catch (e) {
      if (kDebugMode) print('Error reading EXIF data: $e');
      return false;
    }
  }

  static Future<void> addLocationToImage(
    String imagePath,
    double latitude,
    double longitude,
  ) async {
    try {
      Exif exif = await Exif.fromPath(imagePath);
      await exif.writeAttributes({
        'GPSLatitude': latitude.abs().toString(),
        'GPSLatitudeRef': latitude >= 0 ? 'N' : 'S',
        'GPSLongitude': longitude.abs().toString(),
        'GPSLongitudeRef': longitude >= 0 ? 'E' : 'W',
      });

      // Use path_provider to get the documents directory
      Directory dir = await getApplicationDocumentsDirectory();
      // Manually construct the path without 'path' package
      String newPath = '${dir.path}/temp_for_exif.jpg';
      File newFile = File(newPath);
      await newFile.writeAsBytes(await File(imagePath).readAsBytes());

      Exif newExif = await Exif.fromPath(newPath);
      ExifLatLong? latLong = await newExif.getLatLong();
      await newExif.close();

      if (latLong != null && kDebugMode) {
        if (kDebugMode) {
          print('Location embedded: $latitude, $longitude');
        }
      } else if (kDebugMode) {
        print('Failed to embed GPS data');
      }

      await exif.close();
    } catch (e) {
      if (kDebugMode) print('Error writing EXIF data: $e');
    }
  }
}
