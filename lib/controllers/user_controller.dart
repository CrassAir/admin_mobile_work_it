import 'dart:async';

import 'package:admin_mobile_work_it/data/repository/user_repo.dart';
import 'package:admin_mobile_work_it/models/models.dart';
import 'package:admin_mobile_work_it/service/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserRepo userRepo;

  var timer;

  UserController({required this.userRepo});

  List<User> _users = [];
  List<User> _allUsers = [];

  List<User> get users => _users.obs;

  Future<void> getUsers() async {
    Response resp = await userRepo.getUsers();
    if (resp.statusCode != 200) return;

    _users = [];
    _allUsers = [];
    resp.body?.forEach((val) {
      _allUsers.add(User.fromJson(val));
      _users.add(User.fromJson(val));
    });
    update();
  }

  Future<bool> tryFireUser(String username) async {
    Response resp = await userRepo.tryFireUser(username);
    return resp.statusCode == 200;
  }

  Future<void> tryChangeUserCard(String username, Map newCard) async {
    var resp = await userRepo.tryChangeUserCard(username, newCard);
    if (resp.statusCode != 200) return;

    await Get.defaultDialog(
        title: resp.body,
        onConfirm: () async => await tryChangeStatusCard(resp.body, 'change_status'),
        onCancel: () => Get.back()).whenComplete(() => Timer(const Duration(milliseconds: 300), () => Get.back()));
  }

  void searchInList(String value) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), () {
      print(value);
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
