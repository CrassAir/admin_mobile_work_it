import 'dart:async';

import 'package:admin_mobile_work_it/data/repository/user_repo.dart';
import 'package:admin_mobile_work_it/models/models.dart';
import 'package:admin_mobile_work_it/service/api.dart';
import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:get/get.dart';

class UserCtrl extends GetxController {
  final UserRepo userRepo;

  var timer;

  UserCtrl({required this.userRepo});

  List<User> _users = [];
  List<User> _allUsers = [];

  List<User> get users => _users.obs;

  Future<void> getUsers() async {
    loadingSnack();
    Response resp = await userRepo.getUsers();
    Get.closeAllSnackbars();
    if (resp.statusCode != 200) {
      messageFailSnack(title: resp.body);
      return;
    }
    _users = [];
    _allUsers = [];
    resp.body?.forEach((val) {
      _allUsers.add(User.fromJson(val));
      _users.add(User.fromJson(val));
    });
    update();
  }

  Future<bool> tryFireUser(String username) async {
    loadingSnack();
    Response resp = await userRepo.tryFireUser(username);
    Get.closeAllSnackbars();
    if (resp.statusCode == 200) {
      messageSuccessSnack(title: resp.body);
    }
    messageFailSnack(title: resp.body);
    return resp.statusCode == 200;
  }

  Future<void> tryChangeUserCard(String username, Map newCard) async {
    loadingSnack();
    var resp = await userRepo.tryChangeUserCard(username, newCard);
    Get.closeAllSnackbars();
    if (resp.statusCode != 200) {
      messageFailSnack(title: resp.body);
      return;
    }

    await Get.defaultDialog(
            title: resp.body,
            onConfirm: () async =>
                await tryChangeStatusCard(resp.body, 'change_status'),
            onCancel: () => Get.back())
        .whenComplete(
            () => Timer(const Duration(milliseconds: 10000), () => Get.back()));
  }

  Future<void> getUserByCardId(String cardId) async {
    loadingSnack();
    Response resp = await userRepo.getUserByCardId(cardId);
    Get.closeAllSnackbars();
    if (resp.statusCode != 200) {
      messageSuccessSnack(title: 'Карта свободна!');
      update();
      return;
    }
    searchInList(resp.body['full_name']);
  }

  void searchInList(String value) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), () {
      _users.clear();
      _allUsers.forEach((User user) {
        if (user.full_name!.toLowerCase().contains(value.toLowerCase())) {
          _users.add(user);
        }
      });
      update();
    });
  }
}
