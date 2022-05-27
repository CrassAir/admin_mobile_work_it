import 'package:admin_mobile_work_it/data/api_client.dart';
import 'package:get/get.dart';

class UserRepo extends GetxService {
  final ApiClient apiClient;
  final String uri;

  UserRepo({required this.apiClient, required this.uri});

  Future<Response> getUsers() async {
    return await apiClient.getData(uri);
  }

}