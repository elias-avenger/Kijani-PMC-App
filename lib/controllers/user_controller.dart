import 'package:get/get.dart';
import 'package:kijani_pmc_app/models/user.dart';

import '../utilities/local_storage.dart';

class UserController extends GetxController {
  // final String email;
  // final String code;
  User pmc = User();
  LocalStorage myPrefs = LocalStorage();

  var userData = <String, dynamic>{}.obs;
  var userType = " -- ".obs;
  Future<String> authenticate({
    required String email,
    required String code,
  }) async {
    Map<String, dynamic> data = await pmc.checkUser(email: email, code: code);
    if (data['msg'] == 'Found') {
      userData['branch'] = data['data']['branch'];
      userData['coordinator'] = data['data']['coordinator'];
      userData['parishes'] = data['data']['parishes'];
      userType = "Plantation Coordinator".obs;

      var stored = await myPrefs.storeData(key: "userData", data: data['data']);
      if (stored) {
        return "Success";
      } else {
        return "Not Stored";
      }
    } else if (data['msg'] == 'Not Found') {
      return data['msg'];
    } else {
      return "Failure";
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    Map<String, dynamic> storedData = await myPrefs.getData(key: 'userData');
    userData['branch'] = storedData['branch'];
    userData['coordinator'] = storedData['coordinator'];
    userData['parishes'] = storedData['parishes'];
    userType = "Plantation Coordinator".obs;
    return storedData;
  }
}
