import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:dio/dio.dart' as d;
import 'package:get/get.dart';

class ApiClient extends GetConnect implements GetxService {
  final String appBaseUrl;
  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 1);
    _mainHeaders = {'Content-type': 'application/json;'};
  }

  void updateHeaders(String token) {
    _mainHeaders = {'Content-type': 'application/json', 'Authorization': 'Token $token'};
  }

  Future<Response> getData(String uri) async {
    try {
      loadingSnack();
      Response response = await get(uri, headers: _mainHeaders);
      await Get.closeCurrentSnackbar();
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, Map<dynamic, dynamic> data) async {
    try {
      loadingSnack();
      Response response = await post(uri, data, headers: _mainHeaders);
      await Get.closeCurrentSnackbar();
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> patchData(String uri, Map<dynamic, dynamic> data) async {
    try {
      loadingSnack();
      Response response = await patch(uri, data, headers: _mainHeaders);
      await Get.closeCurrentSnackbar();
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> deleteData(String uri) async {
    loadingSnack();
    try {
      Response response = await delete(uri, headers: _mainHeaders);
      return response;
    } catch (e) {
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
