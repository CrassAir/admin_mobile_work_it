import 'dart:async';

import 'package:admin_mobile_work_it/store/controllers/user_ctrl.dart';
import 'package:admin_mobile_work_it/store/models.dart';
import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';

class ChangeOrDeactivateUserCard extends StatefulWidget {
  const ChangeOrDeactivateUserCard({Key? key}) : super(key: key);

  @override
  _ChangeOrDeactivateUserCardState createState() => _ChangeOrDeactivateUserCardState();
}

class _ChangeOrDeactivateUserCardState extends State<ChangeOrDeactivateUserCard> {
  final TextEditingController _editingController = TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  bool search = false;
  Map<String, dynamic>? newCard;
  Timer? timer;
  UserCtrl userCtrl = Get.put(UserCtrl());

  void onSearch() {
    if (!search) {
      customIcon = const Icon(Icons.cancel);
    } else {
      userCtrl.searchInList('');
      clearSearch();
    }
    search = !search;
    setState(() {});
  }

  Future onRefresh() async {
    await userCtrl.getUsers();
    clearSearch();
  }

  // void onChangeUserCard(String username) async {
  //   var resp = await tryChangeUserCard(username, newCard: newCard);
  //   if (resp.isEmpty) return;
  //   await showModalBottomSheet<void>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Container(
  //           height: 400,
  //           child: Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Text(resp, style: const TextStyle(fontSize: 28)),
  //                 const SizedBox(height: 50),
  //                 Container(
  //                     width: 120,
  //                     height: 60,
  //                     child: ElevatedButton(
  //                         onPressed: () async {
  //                           var issued = await tryChangeStatusCard(resp, 'change_status');
  //                           if (issued) Navigator.pop(context);
  //                         },
  //                         style: ElevatedButton.styleFrom(primary: Colors.green),
  //                         child: const Text('Выдать', style: TextStyle(fontSize: 20))))
  //               ],
  //             ),
  //           ),
  //         );
  //       }).whenComplete(() => Timer(const Duration(milliseconds: 300), () => Navigator.pop(context)));
  // }

  @override
  void initState() {
    super.initState();
    userCtrl.getUsers();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var identifier = tagTransform(tag);
      var password = tagGetPassword(tag);
      bool can_be_issued = await userCtrl.getUserByCardId(identifier);
      if (can_be_issued) {
        newCard = {'card_id': identifier, 'password': password};
      }
      customIcon = const Icon(Icons.search);
      // setState(() {});
    });
  }

  void clearSearch() {
    customIcon = const Icon(Icons.search);
    _editingController.clear();
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserCtrl>(builder: (uc) {
      List<User> users = uc.users;
      return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: newCard != null
            ? FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () => setState(() {
                      newCard = null;
                      userCtrl.searchInList('');
                    }),
                child: const Icon(Icons.close))
            : null,
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 50.0,
                floating: true,
                title: search
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).cardColor,
                        ),
                        child: TextField(
                          controller: _editingController,
                          autofocus: true,
                          onChanged: userCtrl.searchInList,
                          decoration: InputDecoration(
                            hintText: 'Поиск',
                            hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      )
                    : Text('Сотрудники', style: Theme.of(context).textTheme.titleLarge),
                actions: [
                  IconButton(
                    onPressed: onSearch,
                    icon: customIcon,
                  )
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => Slidable(
                          endActionPane: ActionPane(motion: const BehindMotion(), children: [
                            SlidableAction(
                              label: 'Поменять карточку',
                              padding: EdgeInsets.all(5),
                              backgroundColor: Colors.red,
                              icon: Icons.refresh,
                              onPressed: (_) {
                                // if (newCard != null) userCtrl.tryChangeUserCard(users[index].username!, newCard!);
                              },
                            ),
                            SlidableAction(
                              label: 'Уволить',
                              backgroundColor: Colors.red,
                              autoClose: true,
                              icon: Icons.clear,
                              onPressed: (_) {
                                // userCtrl.tryFireUser(users[index].username!);
                              },
                            ),
                          ]),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: ExpansionTile(
                              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: Text(
                                  users[index].full_name!.trim().isNotEmpty
                                      ? users[index].full_name!
                                      : users[index].username!,
                                  style: Theme.of(context).textTheme.titleLarge),
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      style: ButtonStyle(
                                        foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                      ),
                                      child: const Text('Уволить'),
                                      onPressed: () {
                                        userCtrl.tryFireUser(users[index].username!);
                                      },
                                    ),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            foregroundColor:
                                                newCard != null ? Colors.yellow : Theme.of(context).disabledColor),
                                        child: const Text('Поменять карту'),
                                        onPressed: () {
                                          if (newCard != null) {
                                            userCtrl.tryChangeUserCard(users[index].username!, newCard!);
                                          }
                                        })
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    childCount: users.length),
              ),
            ],
          ),
        ),
        extendBody: true,
        bottomNavigationBar: AnimatedContainer(
          color: Theme.of(context).canvasColor,
          duration: const Duration(milliseconds: 300),
          height: newCard != null ? 60.0 : 0.0,
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            notchMargin: 4.0,
            color: Colors.transparent,
            child: Center(
                child: Text(
              newCard != null ? newCard!['card_id'] : '',
              style: const TextStyle(color: Colors.white70, fontSize: 30),
            )),
          ),
        ),
      );
    });
  }
}
