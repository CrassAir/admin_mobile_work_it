import 'package:admin_mobile_work_it/models/models.dart';
import 'package:admin_mobile_work_it/models/view_models.dart';
import 'package:admin_mobile_work_it/service/api.dart';
import 'package:admin_mobile_work_it/service/redux.dart';
import 'package:admin_mobile_work_it/service/redux_actions.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../pages/home_page.dart';
import 'login_page.dart';

Duration defaultDurationToLogOff = const Duration(hours: 8);

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  Account? user;
  Map<String?, String?> formData = {'username': null, 'password': null};

  void updateState(){
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // Проверка записи в хранилище
    // Если время последней авторизации + 8 часов меньше настоящего то сделать логофф
    storage.readAll().then((value) async {
      var last_login_date = DateTime.parse(value['last_login_date'] ?? '0001-01-01').add(defaultDurationToLogOff);
      var time_now = DateTime.now().toLocal();
      var username = value['username'];
      var token = value['token'];
      SERVER_IP = value['server_ip'] ?? SERVER_IP;
      PORT = value['port'] ?? PORT;

      // if (last_login_date.millisecondsSinceEpoch <= time_now.millisecondsSinceEpoch) {
      //   await storage.delete(key: 'username');
      //   await storage.delete(key: 'token');
      //   return;
      // }
      var isAuth = await checkToken(token);
      if (isAuth) {
        StoreProvider.dispatch(context, SetUserAction(user: Account(username: username!, token: token)));
        StoreProvider.dispatch(context, ChangeAuth(isAuth: true));
        setState((){});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
        vm: () => Factory(this),
        builder: (BuildContext context, ViewModel vm) {
          if (vm.isAuth) {
            return HomePage(updateState: updateState);
          }
          return LoginPage();
        });
  }
}
