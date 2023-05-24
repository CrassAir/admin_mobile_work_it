import 'dart:async';

import 'package:admin_mobile_work_it/store/controllers/account_ctrl.dart';
import 'package:admin_mobile_work_it/theme.dart';
import 'package:admin_mobile_work_it/routes.dart';
import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:admin_mobile_work_it/dependencies.dart' as dep;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  final AccountCtrl accountCtrl = Get.put(AccountCtrl());

  @override
  void initState() {
    super.initState();

    var brightness = SchedulerBinding.instance.window.platformBrightness;
    storage.read(key: 'isDarkMode').then((value) {
      if (value != null) {
        isDarkMode = value == 'true';
      } else {
        isDarkMode = brightness == Brightness.dark;
      }
      Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    });
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
      theme: Styles.lightMode(context),
      darkTheme: Styles.darkMode(context),
      initialRoute: RouterHelper.initial,
      getPages: RouterHelper.routes,
    );
  }
}
