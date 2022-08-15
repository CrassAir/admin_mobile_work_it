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

  Future<bool> checkToken({String? token, String? server_ip}) async {
    if (token != null && server_ip != null) {
      Response resp = await accountRepo.checkToken(token, server_ip);
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

  Future<bool> tryLoginIn(String username, String password, String server_ip) async {
    String _server_ip = 'https://$server_ip';
    if (int.tryParse(server_ip[0]) != null) {
      _server_ip = 'http://$server_ip';
    }
    Response resp = await accountRepo.tryLoginIn(username, password, _server_ip);
    if (resp.statusCode == 200) {
      _account.token = resp.body['key'];
      _account.username = username;
      await fss.write(key: 'username', value: _account.username);
      await fss.write(key: 'token', value: _account.token);
      await fss.write(key: 'server_ip', value: _server_ip);
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
    await accountRepo.logout();
    await Get.offAndToNamed(RouterHelper.login);
  }
}
