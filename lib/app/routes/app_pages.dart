import 'package:get/get.dart';
import 'package:kijani_pgc_app/app/bindings/user_Binding.dart';
import 'package:kijani_pgc_app/screens/auth/login_screen.dart';
import 'package:kijani_pgc_app/screens/home/home_screen.dart';
part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final pages = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
      binding: UserBinding(),
    ),

    GetPage(name: Routes.HOME, page: () => HomeScreen()),
  ];
}
