import 'package:admin_mobile_work_it/controllers/account_controller.dart';
import 'package:admin_mobile_work_it/controllers/user_controller.dart';
import 'package:admin_mobile_work_it/data/api_client.dart';
import 'package:admin_mobile_work_it/data/repository/account_repo.dart';
import 'package:admin_mobile_work_it/data/repository/user_repo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

String SERVER_IP = 'https://test.ecoferma56.ru';
// String PORT = '9009';

Future<void> init() async {
  // api client
  Get.lazyPut(() => ApiClient(appBaseUrl: '$SERVER_IP/'));

  // account
  Get.lazyPut(() => AccountRepo(apiClient: Get.find(), uri: 'api/'));
  Get.lazyPut(() => AccountController(accountRepo: Get.find(), fss: const FlutterSecureStorage()));

  // users
  Get.lazyPut(() => UserRepo(apiClient: Get.find(), uri: 'api/account/'));
  Get.lazyPut(() => UserController(userRepo: Get.find()));


}