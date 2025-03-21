import 'package:in_app_update/in_app_update.dart';
import 'package:get/get.dart';

class AppUpdateService {
  //check for update
  Future<void> checkForUpdate() async {
    await InAppUpdate.checkForUpdate()
        .then((updateInfo) {
          if (updateInfo.updateAvailability ==
              UpdateAvailability.updateAvailable) {
            updateApp();
          }
        })
        .catchError((error) {
          Get.snackbar('Error', error.toString());
        });
  }

  //function to update the app
  Future<void> updateApp() async {
    await InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((error) {
      Get.snackbar('Error updating App', error.toString());
    });
  }
}
