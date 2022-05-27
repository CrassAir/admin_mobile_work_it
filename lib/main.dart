import 'package:admin_mobile_work_it/controllers/account_ctrl.dart';
import 'package:admin_mobile_work_it/dark_theme.dart';
import 'package:admin_mobile_work_it/pages/home_page.dart';
import 'package:admin_mobile_work_it/pages/login_page.dart';
import 'package:admin_mobile_work_it/routes.dart';
import 'package:admin_mobile_work_it/service/api.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:admin_mobile_work_it/dependencies.dart' as dep;

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  FlutterSecureStorage storage = const FlutterSecureStorage();
  final AccountCtrl accountCtrl = Get.find();

  @override
  void initState() {
    super.initState();

    var brightness = SchedulerBinding.instance!.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark;

    storage.read(key: 'token').then((token) {
      accountCtrl.checkToken(token: token).then((isAuth) {
        if (isAuth) {
          Get.offAndToNamed(RouterHelper.home);
        } else {
          Get.offAndToNamed(RouterHelper.login);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AdminWorkIt',
      debugShowCheckedModeBanner: false,
      theme: Styles.themeData(isDarkMode, context),
      darkTheme: Styles.themeData(isDarkMode, context),
      initialRoute: RouterHelper.initial,
      getPages: RouterHelper.routes,
    );
  }
}
