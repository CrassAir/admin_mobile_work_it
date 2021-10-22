import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String SERVER_URL = 'http://192.168.252.191:9009/';
const String API_URL = 'http://192.168.252.191:9009/api/';

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
    var resp = await dio.post(API_URL + 'check_token/', data: {'token': token});
    return resp.data;
  } on DioError catch (e) {
    print(e);
  }
  return false;
}

Future<bool> sendNewCards(List cards, String type) async {
  var dio = await getDio();
  try {
    var resp = await dio.post(API_URL + 'card/', data: {'cards': cards, 'type': type});
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
    var resp = await dio.get(API_URL + 'account/');
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
    var resp = await dio.post(API_URL + 'swap_user_card/', data: {'username': username});
    return resp.data;
  } on DioError catch (e) {
    return Future.error(e);
  } finally {
    dialog.dismiss();
  }
}
