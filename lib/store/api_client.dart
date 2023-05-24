import 'package:admin_mobile_work_it/constance.dart';
import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:dio/dio.dart' as d;
import 'package:get/get.dart';

class ApiClient extends GetConnect implements GetxService {
  late Map<String, String> _mainHeaders;

  ApiClient() {
    baseUrl = AppConstance.APP_URL;
    timeout = const Duration(seconds: 6);
    _mainHeaders = {'Content-type': 'application/json;'};
  }

  void errorMessage(Response response) {
    if (401 == response.statusCode) {
      updateHeaders('');
    }
    if ([200, 201].contains(response.statusCode)) return;
    if (response.body == null) {
      messageSnack(title: 'Нет ответа от сервера', isSuccess: false);
    } else if (response.body
        .toString()
        .length < 100) {
      if (response.body is String) {
        messageSnack(title: 'Код ошибки: ${response.statusCode}\n${response.body}', isSuccess: false);
      } else {
        String text = '';
        response.body?.forEach((key, value) {
          if (value is List) {
            for (var val in value) {
              text += '\n$val';
            }
          } else {
            text += '\n$value';
          }
        });
        messageSnack(
            title:
            'Код ошибки: ${response.statusCode}$text',
            isSuccess: false);
      }
    } else {
      messageSnack(title: 'Код ошибки: ${response.statusCode}', isSuccess: false);
    }
  }

  void updateHeaders(String token) {
    if (token != '') {
      _mainHeaders = {'Content-type': 'application/json', 'Authorization': 'Token $token'};
    } else {
      _mainHeaders = {'Content-type': 'application/json'};
    }
  }

  Future<Response> getData(String uri, {Map<String, dynamic>? query, bool useLoading = false}) async {
    try {
      if (useLoading) loadingSnack();
      Response response = await get(uri, headers: _mainHeaders, query: query);
      if (useLoading) await Get.closeCurrentSnackbar();
      errorMessage(response);
      return response;
    } catch (e) {
      messageSnack(title: e.toString(), isSuccess: false);
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, Map<String, dynamic>? data,
      {bool useLoading = false, bool withAuth = true}) async {
    try {
      if (useLoading) loadingSnack();
      Response response =
      await post(uri, data, headers: withAuth ? _mainHeaders : {'Content-type': 'application/json'});
      if (useLoading) await Get.closeCurrentSnackbar();
      errorMessage(response);
      return response;
    } catch (e) {
      messageSnack(title: e.toString(), isSuccess: false);
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> patchData(String uri, Map<dynamic, dynamic> data) async {
    try {
      Response response = await patch(uri, data, headers: _mainHeaders);
      errorMessage(response);
      return response;
    } catch (e) {
      messageSnack(title: e.toString(), isSuccess: false);
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> deleteData(String uri) async {
    loadingSnack();
    try {
      Response response = await delete(uri, headers: _mainHeaders);
      errorMessage(response);
      return response;
    } catch (e) {
      messageSnack(title: e.toString(), isSuccess: false);
      return Response(statusCode: 1, statusText: e.toString());
    } finally {
      await Get.closeCurrentSnackbar();
    }
  }

  Future<d.Response> uploadFile(String uri, String filePath) async {
    loadingSnack();
    try {
      d.Dio dio = d.Dio();
      dio.options.headers['Authorization'] = _mainHeaders['Authorization'];
      d.MultipartFile file = await d.MultipartFile.fromFile(filePath);
      d.Response response = await dio.post('$baseUrl$uri', data: d.FormData.fromMap({'avatar': file}));
      await Get.closeCurrentSnackbar();
      return response;
    } catch (e) {
      return d.Response(
          requestOptions: d.RequestOptions(path: '$baseUrl$uri'), statusCode: 1, statusMessage: e.toString());
    } finally {
      await Get.closeCurrentSnackbar();
    }
  }
}
