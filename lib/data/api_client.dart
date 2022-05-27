import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
      Response response = await get(uri, headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, Map<dynamic, dynamic> data) async {
    try {
      Response response = await post(uri, data = data, headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> deleteData(String uri) async {
    try {
      Response response = await delete(uri, headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
