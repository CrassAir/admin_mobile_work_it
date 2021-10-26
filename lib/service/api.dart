import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String SERVER_IP = '192.168.252.191';
String PORT = '9009';

String getServerUrl() {
  var protocol = 'http://';
  var port = ':$PORT';
  if (int.tryParse(SERVER_IP[0]) == null) {
    protocol = 'https://';
    port = '';
  }
  return protocol + SERVER_IP + port + '/';
}

String getServerApiUrl() {
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
    showErrorDialog(e.response!.data.toString() + '\n' + e.message);
  }
  return false;
}

Future<bool> sendNewCards(List<Map<String, String>> cards, String type) async {
  var dio = await getDio();
  try {
    await dio.post(getServerApiUrl() + 'card/', data: {'cards': cards, 'type': type});
    showSuccessDialog('Карточки успешно добавлены');
    return true;
  } on DioError catch (e) {
    showErrorDialog(e.response!.data.toString() + '\n' + e.message);
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
    showErrorDialog(e.response!.data.toString() + '\n' + e.message);
    return Future.error(e);
  } finally {
    dialog.dismiss();
  }
}

Future<String> tryChangeUserCard(String username) async {
  var dio = await getDio();
  var dialog = showLoadingDialog();
  try {
    var resp = await dio.post(getServerApiUrl() + 'account/$username/swap_user_card/');
    return resp.data;
  } on DioError catch (e) {
    showErrorDialog(e.response!.data.toString() + '\n' + e.message);
    return Future.error(e);
  } finally {
    dialog.dismiss();
  }
}

Future<List<dynamic>> getCardForIssueOrReceive() async {
  var dio = await getDio();
  var dialog = showLoadingDialog();
  try {
    var resp = await dio.get(getServerApiUrl() + 'card/get_receive_or_issue/');
    return resp.data;
  } on DioError catch (e) {
    showErrorDialog(e.response!.data.toString() + '\n' + e.message);
    return Future.error(e);
  } finally {
    dialog.dismiss();
  }
}

Future<bool> tryChangeStatusCard(String cardId, String action) async {
  var dio = await getDio();
  var dialog = showLoadingDialog();
  try {
    var resp = await dio.patch(getServerApiUrl() + 'card/$cardId/', data: {'action': action});
    showSuccessDialog(resp.data);
    return true;
  } on DioError catch (e) {
    showErrorDialog(e.response!.data.toString() + '\n' + e.message);
    return false;
  } finally {
    dialog.dismiss();
  }
}
