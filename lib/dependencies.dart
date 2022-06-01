import 'package:admin_mobile_work_it/constance.dart';
import 'package:admin_mobile_work_it/controllers/account_ctrl.dart';
import 'package:admin_mobile_work_it/controllers/card_ctrl.dart';
import 'package:admin_mobile_work_it/controllers/user_ctrl.dart';
import 'package:admin_mobile_work_it/data/api_client.dart';
import 'package:admin_mobile_work_it/data/repository/account_repo.dart';
import 'package:admin_mobile_work_it/data/repository/card_repo.dart';
import 'package:admin_mobile_work_it/data/repository/user_repo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';


Future<void> init() async {
  // api client
  Get.lazyPut<ApiClient>(() => ApiClient(appBaseUrl: AppConstance.APP_URL));

  // account
  Get.lazyPut<AccountRepo>(() => AccountRepo(apiClient: Get.find()));
  Get.lazyPut<AccountCtrl>(() => AccountCtrl(accountRepo: Get.find(), fss: const FlutterSecureStorage()));

  //card
  Get.lazyPut<CardRepo>(() => CardRepo(apiClient: Get.find()));
  Get.lazyPut<CardCtrl>(() => CardCtrl(cardRepo: Get.find()));

  // users
  Get.lazyPut<UserRepo>(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut<UserCtrl>(() => UserCtrl(userRepo: Get.find(), cardCtrl: Get.find()));
}