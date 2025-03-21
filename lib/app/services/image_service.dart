import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:kijani_pgc_app/utils/exif_util.dart';
import 'package:kijani_pgc_app/utils/location.dart';

class ImageService extends GetxService {
  final ImagePicker _imagePicker = ImagePicker();

  // Take picture with camera or gallery and add geotagging if needed
  Future<XFile?> takePicture(ImageSource source) async {
    try {
      XFile? image = await _imagePicker.pickImage(
        source: source,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 90,
      );

      if (image != null) {
        String imagePath = image.path;
        bool hasLocation = await ExifUtils.checkIfImageHasLocation(imagePath);

        if (!hasLocation) {
          Position? position = await Locator().getCurrentPosition();

          if (position != null) {
            await ExifUtils.addLocationToImage(
              imagePath,
              position.latitude,
              position.longitude,
            );
          } else {
            if (kDebugMode) print('Failed to get current position');
          }
        }
      }
      return image;
    } catch (e) {
      if (kDebugMode) print('Error taking picture: $e');
      return null;
    }
  }

  // Select multiple pictures from gallery (no geotagging here as per original)
  Future<List<XFile>?> selectPictures() async {
    try {
      List<XFile> images = await _imagePicker.pickMultiImage(
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 90,
      );
      return images;
    } catch (e) {
      if (kDebugMode) print('Error selecting pictures: $e');
      return null;
    }
  }

  // Show bottom sheet for camera/gallery selection
  Future<XFile?> showBottomSheet(
    BuildContext context, {
    bool showGallery = false,
  }) async {
    final image = await showModalBottomSheet<XFile?>(
      isDismissible: false,
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () async {
                  final XFile? image = await takePicture(ImageSource.camera);
                  Navigator.pop(context, image);
                },
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 20),
              if (showGallery)
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () async {
                    final XFile? image = await takePicture(ImageSource.gallery);
                    Navigator.pop(context, image);
                  },
                ),
            ],
          ),
    );
    return image;
  }
}
