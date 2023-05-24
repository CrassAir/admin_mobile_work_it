import 'package:admin_mobile_work_it/store/actions/account.dart';
import 'package:admin_mobile_work_it/store/models.dart';
import 'package:admin_mobile_work_it/routes.dart';
import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AccountCtrl extends GetxController {
  final AccountActions accountAct = Get.put(AccountActions());
  final FlutterSecureStorage fss = const FlutterSecureStorage();

  AccountCtrl();

  final Account _account = Account();
  bool isAuth = false;

  Future<bool> checkToken({String? token}) async {
    if (token != null) {
      Response resp = await accountAct.checkToken(token);
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
    Response resp = await accountAct.tryLoginIn(username, password);
    if (resp.statusCode == 200) {
      _account.token = resp.body['key'];
      _account.username = username;
      await fss.write(key: 'username', value: _account.username);
      await fss.write(key: 'token', value: _account.token);
      return true;
    }
    if (resp.body != null) messageSnack(title: resp.body['detail'], isSuccess: false);
    return false;
  }

  // Future<bool> tryLoginInByCard(String identifier, String password) async {
  //   Response resp = await accountRepo.tryLoginIn('', password, identifier: identifier);
  //   if (resp.statusCode == 200) {
  //     _account.token = resp.body['key'];
  //     _account.username = resp.body['username'];
  //     print(resp.body);
  //     await fss.write(key: 'username', value: _account.username);
  //     await fss.write(key: 'token', value: _account.token);
  //     return true;
  //   }
  //   // messageSnack(title: resp.body['detail'], isSuccess: false);
  //   return false;
  // }

  Future<void> logout() async {
    await fss.delete(key: 'username');
    await fss.delete(key: 'token');
    await accountAct.logout();
    await Get.offAndToNamed(RouterHelper.login);
  }
}
