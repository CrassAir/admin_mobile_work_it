import 'package:admin_mobile_work_it/pages/landing_page.dart';
import 'package:admin_mobile_work_it/service/redux.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

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
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: StoreProvider(
            store: store!,
            child: MaterialApp(
              title: 'AdminWorkIt',
              debugShowCheckedModeBanner: true,
              theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: Colors.greenAccent,
              ),
              home: LandingPage(),
            )));
  }
}
