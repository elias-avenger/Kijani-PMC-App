import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijani_pgc_app/app/repositories/app_repository.dart';
import 'package:kijani_pgc_app/app/repositories/group_repository.dart';
import 'package:kijani_pgc_app/app/repositories/parish_repository.dart';
import 'package:kijani_pgc_app/app/repositories/user_repository.dart';
import 'package:kijani_pgc_app/app/routes/app_pages.dart';
import 'package:kijani_pgc_app/app/services/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = StorageService();
  await storageService.init();
  Get.put(storageService);
  Get.put(UserRepository());
  Get.put(ParishRepository());
  Get.put(GroupRepository());
  Get.put(AppRepository());

  runApp(const KijaniApp());
}

class KijaniApp extends StatelessWidget {
  const KijaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kijani PGC',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.pages,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
