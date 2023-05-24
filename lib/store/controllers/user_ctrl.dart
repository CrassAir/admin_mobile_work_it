import 'dart:async';

import 'package:admin_mobile_work_it/store/actions/user_repo.dart';
import 'package:admin_mobile_work_it/store/models.dart';
import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:dio/dio.dart' as d;
import 'package:get/get.dart';

class UserCtrl extends GetxController {
  final UserActions userAct = Get.put(UserActions());

  var timer;

  UserCtrl();

  User? user;
  List<User> _users = [];
  List<User> _allUsers = [];

  List<User> get users => _users.obs;

  Future<void> getUsers() async {
    _users.clear();
    Response resp = await userAct.getUsers();
    if (resp.statusCode != 200) {
      if (resp.body != null) messageSnack(title: resp.body, isSuccess: false);
      return;
    }
    _allUsers.clear();
    resp.body?.forEach((val) {
      _allUsers.add(User.fromJson(val));
      _users.add(User.fromJson(val));
    });
    update();
  }

  Future<bool> tryFireUser() async {
    timer?.cancel();
    Response resp = await userAct.tryFireUser(user!.username!);
    if (resp.body != null) messageSnack(title: resp.body, isSuccess: resp.statusCode == 200);
    if (resp.statusCode == 200) {
      _users.clear();
      _allUsers.forEach((element) {
        if (element.username!.toLowerCase() != user!.username!.toLowerCase()) {
          _users.add(element);
        }
      });
      _allUsers = [..._users];
      user = null;
      update();
    }
    return resp.statusCode == 200;
  }

  Future<bool> tryChangeUserCard(String username, Map<String, dynamic> newCard) async {
    var resp = await userAct.tryChangeUserCard(username, newCard);
    if (resp.body != null) messageSnack(title: resp.body, isSuccess: resp.statusCode == 200);
    return resp.statusCode == 200;
  }

  Future<bool> getUserByCardId(String cardId) async {
    Response resp = await userAct.getUserByCardId(cardId);
    if (resp.statusCode != 200) {
      messageSnack(title: 'Карта свободна!', isSuccess: true);
      _users = [..._allUsers];
      update();
      return true;
    }
    String find_user = resp.body['username'];
    for (var user in _allUsers) {
      if (user.username!.toLowerCase() == find_user.toLowerCase()) {
        _users.clear();
        _users.add(user);
        update();
        return true;
      }
    }
    messageSnack(title: 'Данная карта принадлежит $find_user, ее нельзя использовать для выдачи!', isSuccess: false);
    return false;
  }

  Future<void> tryUploadAvatar(String username, String filePath) async {
    print(filePath);
    d.Response resp = await userAct.tryUploadAvatar(username, filePath);
    messageSnack(title: resp.data.toString(), isSuccess: resp.statusCode == 200);
    update();
  }

  void selectUser(String username) {
    user = _users.firstWhereOrNull((element) => element.username == username);
  }

  void searchInList(String value) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), () {
      _users.clear();
      _allUsers.forEach((User user) {
        if (user.full_name!.toLowerCase().contains(value.toLowerCase()) ||
            user.username!.toLowerCase() == value.toLowerCase()) {
          _users.add(user);
        }
      });
      if (value.isEmpty) {
        _users = [..._allUsers];
      }
      update();
    });
  }
}
