import 'package:get/get.dart';
import 'package:kijani_pmc_app/models/branch.dart';
import 'package:kijani_pmc_app/utilities/http_airtable.dart';

import '../utilities/local_storage.dart';

class UserController extends GetxController {
  // final String email;
  // final String code;
  HttpAirtable useAirtable = HttpAirtable();

  String myBase = "app9yul6FMnVUm7L4";
  String myTable = "Parishes";

  LocalStorage myPrefs = LocalStorage();

  var branchData = <String, dynamic>{}.obs;
  //var userType = " -- ".obs;
  Future<String> authenticate({
    required String email,
    required String code,
  }) async {
    Map<String, dynamic> data = await useAirtable.checkUser(
      email: email,
      code: code,
      baseId: myBase,
      table: myTable,
    );
    if (data['msg'] == 'Found') {
      final userBranch = Branch.fromJson(data['data']);

      branchData['branch'] = data['data']['branch'];
      branchData['coordinator'] = data['data']['coordinator'];
      branchData['parishes'] = data['data']['parishes'];

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

  Future<Map<String, dynamic>> getBranchData() async {
    Map<String, dynamic> storedData = await myPrefs.getData(key: 'userData');
    branchData['branch'] = storedData['branch'];
    branchData['coordinator'] = storedData['coordinator'];
    branchData['parishes'] = storedData['parishes'];
    //userType = "Plantation Coordinator".obs;
    return storedData;
  }
}
