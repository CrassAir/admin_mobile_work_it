import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String SERVER_IP = '192.168.252.191';
String PORT = '9009';

String getServerUrl(){
  var protocol = 'http://';
  var port = ':$PORT';
  if (int.tryParse(SERVER_IP[0]) == null){
    protocol = 'https://';
    port = '';
  }
  return protocol + SERVER_IP + port + '/';
}

String getServerApiUrl(){
  return getServerUrl() + 'api/';
}

Future<Dio> getDio() {
  var dio = Dio();
  const _storage = FlutterSecureStorage();
  var dio_inter = _storage.read(key: 'token').then((value) {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      options.headers['Authorization'] = 'Token $value';
      handler.next(options);
    }));
    return dio;
  });
  return Future.value(dio_inter);
}

Future<bool> checkToken(String? token) async {
  var dio = Dio();
  try {
    var resp = await dio.post(getServerApiUrl() + 'check_token/', data: {'token': token});
    return resp.data;
  } on DioError catch (e) {
    print(e);
  }
  return false;
}

Future<bool> sendNewCards(List cards, String type) async {
  var dio = await getDio();
  try {
    var resp = await dio.post(getServerApiUrl() + 'card/', data: {'cards': cards, 'type': type});
    if (resp.statusCode == 200) return true;
  } on DioError catch (e) {
    print(e);
  }
  return false;
}

Future<List> getUsers() async {
  var dio = await getDio();
  var dialog = showLoadingDialog();
  try {
    var resp = await dio.get(getServerApiUrl() + 'account/');
    return resp.data;
  } on DioError catch (e) {
    return Future.error(e);
  } finally {
    dialog.dismiss();
  }
}

Future<String> tryChangeUserCard(String username) async {
  var dio = await getDio();
  var dialog = showLoadingDialog();
  try {
    var resp = await dio.post(getServerApiUrl() + 'swap_user_card/', data: {'username': username});
    return resp.data;
  } on DioError catch (e) {
    return Future.error(e);
  } finally {
    dialog.dismiss();
  }
}
