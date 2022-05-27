import 'dart:async';

import 'package:admin_mobile_work_it/controllers/user_controller.dart';
import 'package:admin_mobile_work_it/models/models.dart';
import 'package:admin_mobile_work_it/screens/detail_user.dart';
import 'package:admin_mobile_work_it/service/api.dart';
import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
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
  Widget customSearchBar = const Text('Сотрудники');
  Map? newCard;
  Timer? timer;
  var userController = Get.find<UserController>();

  void onSearch() {
    if (customIcon.icon == Icons.search) {
      customIcon = const Icon(Icons.cancel);
      customSearchBar = Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          alignment: Alignment.center,
          width: 250,
          height: 30,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 5),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _editingController,
                      autofocus: true,
                      onChanged: userController.searchInList,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      );
    } else {
      customIcon = const Icon(Icons.search);
      customSearchBar = const Text('Сотрудники');
      _editingController.clear();
      userController.searchInList('');
    }
    setState(() {});
  }

  Future onRefresh() async {
    await userController.getUsers();
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
    userController.getUsers();
    // getUsers().then((value) {
    //   allItems.addAll(value);
    //   _items.addAll(value);
    //   setState(() {});
    // });
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var identifier = tagTransform(tag);
      var password = tagGetPassword(tag);
      var user = await getUserByCardId(identifier);
      newCard = {'card_id': identifier, 'password': password};
      print(user);
      if (user != null) {
        userController.searchInList(user['full_name']);
      }
      customIcon = const Icon(Icons.search);
      customSearchBar = const Text('Сотрудники');
      // setState(() {});
    });
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (uc) {
      List<User> users = uc.users;
      return Scaffold(
          floatingActionButton: newCard != null
              ? FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () => setState(() {
                        newCard = null;
                        userController.searchInList('');
                      }),
                  child: const Icon(Icons.close))
              : null,
          body: RefreshIndicator(
            onRefresh: onRefresh,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 50.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: customSearchBar,
                    background: const FlutterLogo(),
                  ),
                  actions: [
                    IconButton(
                      onPressed: onSearch,
                      icon: customIcon,
                    )
                  ],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) => Card(
                            child: OpenContainer(
                                openColor: Theme.of(context).cardColor,
                                closedColor: Theme.of(context).cardColor,
                                closedBuilder: (context, action) {
                                  return ListTile(
                                    tileColor: Theme.of(context).cardColor,
                                    title: Text(
                                        users[index].full_name!.trim().isNotEmpty
                                            ? users[index].full_name!
                                            : users[index].username!,
                                        style: const TextStyle(fontSize: 24)),
                                    subtitle:
                                        newCard != null ? Text('Карточка для замены -> ${newCard!['card_id']}') : null,
                                  );
                                },
                                openBuilder: (context, action) => DetailUser(user: users[index], newCard: newCard)),
                            //   ExpansionTile(
                            //       key: UniqueKey(),
                            //       // leading: const Icon(Icons.account_circle),
                            //       title: Text(
                            //           _items[index]['full_name'].trim().isNotEmpty
                            //               ? _items[index]['full_name']
                            //               : _items[index]['username'],
                            //           style: const TextStyle(fontSize: 24)),
                            //       subtitle: newCard != null ? Text('Карточка для замены -> ${newCard!['card_id']}') : null,
                            //       childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
                            //       children: <Widget>[
                            //         Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            //           Container(
                            //               width: 150,
                            //               child: ElevatedButton(
                            //                   onPressed: () => onChangeUserCard(_items[index]['username']),
                            //                   child: const Text('Поменять карту'))),
                            //           Container(
                            //               width: 150,
                            //               child: ElevatedButton(
                            //                   style: ElevatedButton.styleFrom(primary: Colors.red),
                            //                   onPressed: () => tryFireUser(_items[index]['username']).then((value) => {if (value) Navigator.pop(context)}),
                            //                   child: const Text('Уволить сотрудника'))),
                            //         ])
                            //       ]),
                          ),
                      childCount: users.length),
                )
              ],
            ),
          ));
    });
  }
}
