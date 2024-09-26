import 'package:get/get.dart';
import 'package:kijani_pmc_app/services/aws.dart';
import 'package:kijani_pmc_app/services/http_airtable.dart';
import 'package:kijani_pmc_app/services/internet_check.dart';

import '../services/local_storage.dart';

class ReportsController extends GetxController {
  HttpAirtable airtableAccess = HttpAirtable();
  LocalStorage myPrefs = LocalStorage();
  AWSService awsAccess = AWSService();
  InternetCheck internetCheck = InternetCheck();
  var unSyncedReports = 0.obs;

  Future<String> submitReport({
    required Map<String, dynamic> reportData,
  }) async {
    //convert image file paths to usable image names and paths
    // reportData['Garden challenges photos'] = ImageNamesAndPaths()
    //     .getImagesNamesAndPaths(
    //         imagesData: reportData['Garden challenges photos']);

    //upload images to aws
    Map<String, dynamic> photos = reportData['Garden challenges photos'];
    int numPhotos = photos.length;
    Map<String, dynamic> uploaded = await awsAccess.uploadPhotosMap(
        photosData: photos, numPhotos: numPhotos);

    if (uploaded['msg'] == "success") {
      //prepare data to submit to airtable
      Map<String, dynamic> dataToSubmit = reportData;

      //convert uploaded photos urls to a comma separated string
      Map<String, dynamic> photosUrls = uploaded['data'];
      String photosString = "";
      for (String url in photosUrls.keys) {
        photosString += url == photosUrls.keys.last
            ? photosUrls[url]
            : "${photosUrls[url]}, ";
      }
      dataToSubmit['Garden challenges photos'] = photosString;

      // submit data
      Map<String, dynamic> response = await airtableAccess.createRecord(
        data: dataToSubmit,
        baseId: 'appoW7X8Lz3bIKpEE',
        table: 'PMC Reports',
      );
      if (response.keys.first == 'success') {
        return response['success'];
      } else {
        return await storeFailedReport(data: reportData)
            ? "${response['failed']}. Stored!"
            : "${response['failed']}. Failed to store!";
      }
    } else {
      return await storeFailedReport(data: reportData)
          ? "${uploaded['msg']}. Stored!"
          : "${uploaded['msg']}. Failed to store!";
    }
  }

  Future<bool> storeFailedReport({required data}) async {
    Map<String, dynamic> storedReports =
        await myPrefs.getData(key: 'failedReports');
    int num = 0;
    if (storedReports.isNotEmpty) {
      num = int.parse(storedReports.keys.last.split('-').last);
    }
    storedReports['report-${num + 1}'] = data;
    return myPrefs.storeData(key: 'failedReports', data: storedReports);
  }

  Future<int> countUnSyncedReports() async {
    Map<String, dynamic> reportsData =
        await myPrefs.getData(key: 'failedReports');
    return reportsData.length;
  }

  void uploadUnSyncedReports() async {
    Map<String, dynamic> reportsData =
        await myPrefs.getData(key: 'failedReports');
    String awsAccessMsg = await internetCheck.getAWSConMessage();
    String airtableAccessMsg = await internetCheck.getAirtableConMessage();
    while (awsAccessMsg == "connected" &&
        airtableAccessMsg == "connected" &&
        reportsData.isNotEmpty) {
      String firstKey = reportsData.keys.first;
      Map<String, dynamic> targetData = reportsData[firstKey];

      //upload images to aws
      Map<String, dynamic> photos = targetData['Garden challenges photos'];
      int numPhotos = photos.length;
      Map<String, dynamic> uploaded = await awsAccess.uploadPhotosMap(
          photosData: photos, numPhotos: numPhotos);
      if (uploaded['msg'] == "success") {
        //prepare data to submit to airtable
        Map<String, dynamic> dataToSubmit = targetData;

        //convert uploaded photos urls to a comma separated string
        Map<String, dynamic> photosUrls = uploaded['data'];
        String photosString = "";
        for (String url in photosUrls.keys) {
          photosString += url == photosUrls.keys.last
              ? photosUrls[url]
              : "${photosUrls[url]}, ";
        }
        dataToSubmit['Garden challenges photos'] = photosString;

        // submit data
        Map<String, dynamic> response = await airtableAccess.createRecord(
          data: dataToSubmit,
          baseId: 'appoW7X8Lz3bIKpEE',
          table: 'PMC Reports',
        );
        if (response.keys.first == 'success') {
          await myPrefs.removeUnSyncedData(
            type: 'failedReports',
            key: firstKey,
            data: targetData,
          );
        }
      }
      reportsData = await myPrefs.getData(key: 'failedReports');
      awsAccessMsg = await internetCheck.getAWSConMessage();
      airtableAccessMsg = await internetCheck.getAirtableConMessage();
    }
    unSyncedReports = (await countUnSyncedReports()) as RxInt;
  }
}
