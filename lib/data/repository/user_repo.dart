import 'package:admin_mobile_work_it/constance.dart';
import 'package:admin_mobile_work_it/data/api_client.dart';
import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:get/get.dart';

class UserRepo extends GetxService {
  final ApiClient apiClient;

  UserRepo({required this.apiClient});

  Future<Response> getUsers() async {
    return await apiClient.getData(AppConstance.ACCOUNT_URL);
  }

  Future<Response> tryFireUser(String username) async {
    return await apiClient
        .deleteData('${AppConstance.ACCOUNT_URL}$username/fire_employee/');
  }

  Future<Response> tryChangeUserCard(String username, Map newCard) async {
    return await apiClient.postData(
        '${AppConstance.ACCOUNT_URL}$username/swap_user_card/', newCard);
  }

  Future<Response> getUserByCardId(String cardId) async {
    return await apiClient
        .getData('${AppConstance.CARD_URL}$cardId/get_user_by_card_id/');
  }
}
