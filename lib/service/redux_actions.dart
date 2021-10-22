import 'dart:async';

import 'package:admin_mobile_work_it/models/models.dart';
import 'package:admin_mobile_work_it/service/redux.dart';
import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:async_redux/async_redux.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api.dart';

class SetUserAction extends ReduxAction<AppState> {
  final User user;

  SetUserAction({required this.user});

  @override
  Future<AppState> reduce() async {
    return state.copy(user: user);
  }
}

class TryAuth extends ReduxAction<AppState> {
  final String username;
  final String password;

  TryAuth({required this.username, required this.password});

  @override
  Future<AppState> reduce() async {
    var dio = Dio();
    var storage = const FlutterSecureStorage();
    var dialog = showLoadingDialog();
    try {
      var response = await dio.post(SERVER_URL + 'rest-auth/login/', data: {'username': username, 'password': password});
      var token = response.data['key'].toString();
      var user = User(username: username, token: token);
      await storage.write(key: 'username', value: username);
      await storage.write(key: 'token', value: token);
      await storage.write(key: 'last_login_date', value: DateTime.now().toLocal().toString());
      print(response.data);
      return state.copy(user: user, isAuth: true);
    } on DioError catch (e) {
      print(e);
      return state;
    } finally {
      dialog.dismiss();
    }
  }
}

class ChangeAuth extends ReduxAction<AppState> {
  final bool isAuth;

  ChangeAuth({required this.isAuth});

  @override
  Future<AppState> reduce() async {
      return state.copy(isAuth: isAuth);
  }
}
