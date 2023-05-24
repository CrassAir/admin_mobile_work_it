import 'package:admin_mobile_work_it/constance.dart';
import 'package:admin_mobile_work_it/store/api_client.dart';
import 'package:get/get.dart';

class AccountActions extends GetxService {
  final ApiClient apiClient = Get.find();

  AccountActions();

  Future<Response> checkToken(String token) async {
    Response resp = await apiClient.postData('/${AppConstance.API_URL}check_token/', {'token': token}, useLoading: false);
    if (resp.statusCode == 200) {
      apiClient.updateHeaders(token);
    }
    return resp;
  }

  Future<Response> tryLoginIn(String username, String password, {String identifier = ''}) async {
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
