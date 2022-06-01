import 'dart:async';

import 'package:admin_mobile_work_it/controllers/card_ctrl.dart';
import 'package:admin_mobile_work_it/data/repository/user_repo.dart';
import 'package:admin_mobile_work_it/models/models.dart';
import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:dio/dio.dart' as d;
import 'package:get/get.dart';

class UserCtrl extends GetxController {
  final UserRepo userRepo;
  final CardCtrl cardCtrl;

  var timer;

  UserCtrl({required this.userRepo, required this.cardCtrl});

  User? user;
  List<User> _users = [];
  List<User> _allUsers = [];

  List<User> get users => _users.obs;


  Future<void> getUsers() async {
    Response resp = await userRepo.getUsers();
    if (resp.statusCode != 200) {
      print(resp.body);
      messageSnack(title: resp.body, isSuccess: false);
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

  Future<bool> tryFireUser() async {
    timer?.cancel();
    Response resp = await userRepo.tryFireUser(user!.username!);
    messageSnack(title: resp.body, isSuccess: resp.statusCode == 200);
    if (resp.statusCode == 200) {
      _users = [];
      _allUsers.forEach((element) {
        if (element.username!.toLowerCase() != user!.username!.toLowerCase()) {
          _users.add(element);
        }
      });
      _allUsers = _users;
      user = null;
      update();
    }
    return resp.statusCode == 200;
  }

  Future<bool> tryChangeUserCard(String username, Map newCard) async {
    var resp = await userRepo.tryChangeUserCard(username, newCard);
    messageSnack(title: resp.body, isSuccess: resp.statusCode == 200);
    return resp.statusCode == 200;
  }

  Future<void> getUserByCardId(String cardId) async {
    Response resp = await userRepo.getUserByCardId(cardId);
    if (resp.statusCode != 200) {
      messageSnack(title: 'Карта свободна!', isSuccess: true);
      update();
      return;
    }
    searchInList(resp.body['username']);
  }

  Future<void> tryUploadAvatar(String username, String filePath) async {
    print(filePath);
    d.Response resp = await userRepo.tryUploadAvatar(username, filePath);
    print(resp.statusCode);
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
      update();
    });
  }
}
