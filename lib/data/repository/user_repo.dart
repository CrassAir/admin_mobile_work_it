import 'package:admin_mobile_work_it/data/api_client.dart';
import 'package:get/get.dart';

class UserRepo extends GetxService {
  final ApiClient apiClient;
  final String uri;

  UserRepo({required this.apiClient, required this.uri});

  Future<Response> getUsers() async {
    return await apiClient.getData(uri);
  }

  Future<Response> tryFireUser(String username) async {
    return await apiClient.deleteData('$uri$username/fire_employee/');
  }

  Future<Response> tryChangeUserCard(String username, Map newCard) async {
    return await apiClient.postData('$uri$username/swap_user_card/', newCard);
  }

}