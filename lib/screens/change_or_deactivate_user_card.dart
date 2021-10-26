import 'dart:async';

import 'package:admin_mobile_work_it/service/api.dart';
import 'package:flutter/material.dart';

class ChangeOrDeactivateUserCard extends StatefulWidget {
  const ChangeOrDeactivateUserCard({Key? key}) : super(key: key);

  @override
  _ChangeOrDeactivateUserCardState createState() => _ChangeOrDeactivateUserCardState();
}

class _ChangeOrDeactivateUserCardState extends State<ChangeOrDeactivateUserCard> {
  final _items = [];
  final allItems = [];
  final GlobalKey<SliverAnimatedListState> _key = GlobalKey<SliverAnimatedListState>();
  final TextEditingController _editingController = TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Сотрудники');
  Timer? timer;

  void _addItem(Map item) {
    _items.insert(0, item);
    _key.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
  }

  void removeAll() {
    for (var i = 0; i <= _items.length - 1; i++) {
      _key.currentState!.removeItem(0, (BuildContext context, Animation<double> animation) => Container());
    }
    _items.clear();
  }

  void searchInList(String value) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), () {
      removeAll();
      allItems.forEach((element) {
        if (element['full_name'].toLowerCase().contains(value.toLowerCase())) {
          _addItem(element);
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 5),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
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
      removeAll();
      allItems.forEach((element) {
        _addItem(element);
      });
    }
    setState(() {});
  }

  Future onRefresh() async {
    var resp = await getUsers();
    removeAll();
    if (allItems.length != resp.length) allItems.addAll(resp);
    resp.forEach((element) {
      _addItem(element);
    });
    if (resp.isNotEmpty) return Future.value();
    return Future.delayed(const Duration(seconds: 5));
  }

  void onChangeUserCard(String username) async {
    var resp = await tryChangeUserCard(username);
    if (resp.isEmpty) return;
    await showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 400,
            color: Colors.black45,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(resp, style: const TextStyle(color: Colors.white, fontSize: 28)),
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
                          child: const Text('Выдать', style: TextStyle(color: Colors.white, fontSize: 20))))
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
      print(value);
      value.forEach((element) {
        _addItem(element);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SliverAnimatedList(
            key: _key,
            initialItemCount: 0,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) => SizeTransition(
              sizeFactor: animation,
              child: Card(
                child: ExpansionTile(
                    // leading: const Icon(Icons.account_circle),
                    title: Text(_items[index]['full_name'].trim().isNotEmpty ? _items[index]['full_name'] : _items[index]['username'],
                        style: const TextStyle(fontSize: 24)),
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
                    children: <Widget>[
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        Container(
                            width: 150,
                            child: ElevatedButton(onPressed: () => onChangeUserCard(_items[index]['username']), child: const Text('Поменять карту'))),
                        // const SizedBox(width: 20),
                        // Container(
                        //     width: 160,
                        //     child: ElevatedButton(
                        //         onPressed: () => tryChangeStatusCard( _items[index]['username']),
                        //         style: ElevatedButton.styleFrom(primary: Colors.red),
                        //         child: const Text('Заблокировать карту'))),
                      ])
                    ]),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
