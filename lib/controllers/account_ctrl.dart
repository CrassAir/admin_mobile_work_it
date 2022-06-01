import 'package:admin_mobile_work_it/data/repository/account_repo.dart';
import 'package:admin_mobile_work_it/models/models.dart';
import 'package:admin_mobile_work_it/routes.dart';
import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AccountCtrl extends GetxController {
  final AccountRepo accountRepo;
  final FlutterSecureStorage fss;

  AccountCtrl({required this.accountRepo, required this.fss});

  final Account _account = Account();
  bool isAuth = false;

  Future<bool> checkToken({String? token}) async {
    if (token != null) {
      Response resp = await accountRepo.checkToken(token);
      if (resp.statusCode == 200) {
        _account.token = token;
        isAuth = true;
        return true;
      }
      if (resp.statusCode == 401 || resp.body == false) {
        await logout();
      }
    }
    return false;
  }

  Future<bool> tryLoginIn(String username, String password) async {
    Response resp = await accountRepo.tryLoginIn(username, password);
    if (resp.statusCode == 200) {
      _account.token = resp.body['key'];
      _account.username = username;
      await fss.write(key: 'username', value: _account.username);
      await fss.write(key: 'token', value: _account.token);
      return true;
    }
    messageSnack(title: resp.body['detail'], isSuccess: false);
    return false;
  }

  Future<void> logout() async {
    await fss.delete(key: 'username');
    await fss.delete(key: 'token');
    await accountRepo.logout();
    await Get.offAndToNamed(RouterHelper.login);
  }
}
