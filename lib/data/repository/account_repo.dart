import 'package:admin_mobile_work_it/constance.dart';
import 'package:admin_mobile_work_it/data/api_client.dart';
import 'package:get/get.dart';

class AccountRepo extends GetxService {
  final ApiClient apiClient;

  AccountRepo({required this.apiClient});

  Future<Response> checkToken(String token, String server_ip) async {
    apiClient.updateBaseUrl(server_ip);
    Response resp = await apiClient.postData('/${AppConstance.API_URL}check_token/', {'token': token}, useLoading: false);
    if (resp.statusCode == 200) {
      apiClient.updateHeaders(token);
    }
    return resp;
  }

  Future<Response> tryLoginIn(String username, String password, String server_ip, {String identifier = ''}) async {
    apiClient.updateBaseUrl(server_ip);
    Response resp = await apiClient
        .postData('/rest-auth/login/', {'username': username, 'identifier': identifier, 'password': password, 'source': 'admin_app'}, withAuth: false);
    if (resp.statusCode == 200) {
      apiClient.updateHeaders(resp.body['key']);
    }
    return resp;
  }

  Future<void> logout() async {
    apiClient.updateHeaders('');
  }
}
