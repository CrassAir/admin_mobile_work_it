import 'dart:async';

import 'package:admin_mobile_work_it/service/api.dart';
import 'package:flutter/material.dart';

class ChangeUserCard extends StatefulWidget {
  const ChangeUserCard({Key? key}) : super(key: key);

  @override
  _ChangeUserCardState createState() => _ChangeUserCardState();
}

class _ChangeUserCardState extends State<ChangeUserCard> {
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

  void onSendData(String username) async {
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
                children: <Widget>[Text(resp, style: const TextStyle(color: Colors.white, fontSize: 28))],
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
                child: ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: Text(_items[index]['full_name'].trim().isNotEmpty ? _items[index]['full_name'] : _items[index]['username'],
                      style: const TextStyle(fontSize: 24)),
                  onLongPress: () => onSendData(_items[index]['username']),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
