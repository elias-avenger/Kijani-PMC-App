import 'package:get/get.dart';
import 'package:kijani_pgc_app/app/controllers/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController());
  }
}
