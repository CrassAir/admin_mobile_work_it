import 'dart:async';

import 'package:admin_mobile_work_it/controllers/account_ctrl.dart';
import 'package:admin_mobile_work_it/dark_theme.dart';
import 'package:admin_mobile_work_it/routes.dart';
import 'package:admin_mobile_work_it/service/utils.dart';
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

    var brightness = SchedulerBinding.instance.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    tryAuth();
  }

  void tryAuth() async {
    for (int i = 0; i < 3; i++) {
      String? token = await storage.read(key: 'token');
      if (token != null) {
        bool isAuth = await accountCtrl.checkToken(token: token);
        if (isAuth) {
          await Get.offNamed(RouterHelper.home);
          return;
        }
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
    messageSnack(title: 'Token is null', isSuccess: false);
    await Get.offNamed(RouterHelper.login);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AdminWorkIt',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      theme: Styles.themeData(isDarkMode, context),
      darkTheme: Styles.themeData(isDarkMode, context),
      initialRoute: RouterHelper.initial,
      getPages: RouterHelper.routes,
    );
  }
}
