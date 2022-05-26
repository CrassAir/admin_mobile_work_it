import 'package:admin_mobile_work_it/dark_theme.dart';
import 'package:admin_mobile_work_it/pages/landing_page.dart';
import 'package:admin_mobile_work_it/service/redux.dart';
import 'package:admin_mobile_work_it/service/redux_actions.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:overlay_support/overlay_support.dart';

import 'models/view_models.dart';

Store<AppState>? store;

void main() {
  var state = AppState.initialState();
  store = Store<AppState>(initialState: state);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();

    var brightness = SchedulerBinding.instance!.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: StoreProvider(
            store: store!,
            child: MaterialApp(
              title: 'AdminWorkIt',
              debugShowCheckedModeBanner: true,
              theme: Styles.themeData(isDarkMode, context),
              darkTheme: Styles.themeData(isDarkMode, context),
              home: LandingPage(),
            )));
  }
}
