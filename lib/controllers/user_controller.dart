import 'package:kijani_pmc_app/models/user.dart';

class UserController {
  final String email;
  final String code;
  User pmc = User();
  UserController({required this.email, required this.code});
  Future<String> authenticate() async {
    Map<String, dynamic> data = await pmc.checkUser(email: email, code: code);
    if (data['msg'] == 'Found') {
      var stored = await pmc.storeData(data: data['data']);
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
    return await pmc.getUserData();
  }
}
