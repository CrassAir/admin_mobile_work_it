import 'dart:async';

import 'package:admin_mobile_work_it/service/api.dart';
import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class ChangeOrDeactivateUserCard extends StatefulWidget {
  const ChangeOrDeactivateUserCard({Key? key}) : super(key: key);

  @override
  _ChangeOrDeactivateUserCardState createState() => _ChangeOrDeactivateUserCardState();
}

class _ChangeOrDeactivateUserCardState extends State<ChangeOrDeactivateUserCard> {
  final _items = [];
  final allItems = [];
  final TextEditingController _editingController = TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Сотрудники');
  Map? newCard;
  Timer? timer;

  void searchInList(String value) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), () {
      _items.clear();
      allItems.forEach((element) {
        if (element['full_name'].toLowerCase().contains(value.toLowerCase())) {
          _items.add(element);
        }
      });
      setState(() {});
    });
  }

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
                      onChanged: searchInList,
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
      _items.clear();
      _items.addAll(allItems);
    }
    setState(() {});
  }

  Future onRefresh() async {
    var resp = await getUsers();
    _items.clear();
    if (allItems.length != resp.length) allItems.addAll(resp);
    _items.addAll(resp);
    setState(() {});
    if (resp.isNotEmpty) return Future.value();
    return Future.delayed(const Duration(seconds: 5));
  }

  void onChangeUserCard(String username) async {
    var resp = await tryChangeUserCard(username, newCard: newCard);
    if (resp.isEmpty) return;
    await showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 400,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(resp, style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 50),
                  Container(
                      width: 120,
                      height: 60,
                      child: ElevatedButton(
                          onPressed: () async {
                            var issued = await tryChangeStatusCard(resp, 'change_status');
                            if (issued) Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(primary: Colors.green),
                          child: const Text('Выдать', style: TextStyle(fontSize: 20))))
                ],
              ),
            ),
          );
        }).whenComplete(() => Timer(const Duration(milliseconds: 300), () => Navigator.pop(context)));
  }

  @override
  void initState() {
    super.initState();
    getUsers().then((value) {
      allItems.addAll(value);
      _items.addAll(value);
      setState(() {});
    });
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var identifier = tagTransform(tag);
      var password = tagGetPassword(tag);
      var user = await getUserByCardId(identifier);
      newCard = {'card_id': identifier, 'password': password};
      print(user);
      if (user != null) {
        _items.clear();
        _items.add(user);
      }
      customIcon = const Icon(Icons.search);
      customSearchBar = const Text('Сотрудники');
      setState(() {});
    });
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: newCard != null
            ? FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () => setState(() {
                      newCard = null;
                      _items.clear();
                      _items.addAll(allItems);
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
                          child: ExpansionTile(
                              key: UniqueKey(),
                              // leading: const Icon(Icons.account_circle),
                              title: Text(
                                  _items[index]['full_name'].trim().isNotEmpty
                                      ? _items[index]['full_name']
                                      : _items[index]['username'],
                                  style: const TextStyle(fontSize: 24)),
                              subtitle: newCard != null ? Text('Карточка для замены -> ${newCard!['card_id']}') : null,
                              childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
                              children: <Widget>[
                                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                  Container(
                                      width: 150,
                                      child: ElevatedButton(
                                          onPressed: () => onChangeUserCard(_items[index]['username']),
                                          child: const Text('Поменять карту'))),
                                  Container(
                                      width: 150,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(primary: Colors.red),
                                          onPressed: () => tryFireUser(_items[index]['username']).then((value) => {if (value) Navigator.pop(context)}),
                                          child: const Text('Уволить сотрудника'))),
                                ])
                              ]),
                        ),
                    childCount: _items.length),
              )
            ],
          ),
        ));
  }
}
