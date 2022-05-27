import 'package:admin_mobile_work_it/data/api_client.dart';
import 'package:get/get.dart';

class AccountRepo extends GetxService {
  final ApiClient apiClient;
  final String uri;

  AccountRepo({required this.apiClient, required this.uri});

  Future<Response> checkToken(String token) async {
    Response resp = await apiClient.postData(uri + 'check_token/', {'token': token});
    if (resp.statusCode == 200) {
      apiClient.updateHeaders(token);
    }
    return resp;
  }

  Future<Response> tryLoginIn(String username, String password) async {
    Response resp = await apiClient
        .postData('rest-auth/login/', {'username': username, 'password': password, 'source': 'admin_app'});
    if (resp.statusCode == 200) {
      apiClient.updateHeaders(resp.body['key']);
    }
    return resp;
  }

  Future<void> logout() async {
    apiClient.updateHeaders('');
  }
}
