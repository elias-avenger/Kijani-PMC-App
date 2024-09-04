import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:kijani_pmc_app/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await FMTCObjectBoxBackend().initialise();
  // await const FMTCStore('mapStore').manage.create();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> data = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkForUpdate();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    //data = await kActions.updateUserData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          update();
        }
      });
    }).catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

  void update() async {
    if (kDebugMode) {
      print('Updating');
    }

    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: //isLoading
            //? const LoadingScreen():
            data.isEmpty
                ? const LoginScreen()
                : const MainScreen() //UserPage(userData: data),
        );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
