import 'dart:async';

import 'package:admin_mobile_work_it/service/api.dart';
import 'package:flutter/material.dart';

class CardForIssueOrReceive extends StatefulWidget {
  const CardForIssueOrReceive({Key? key}) : super(key: key);

  @override
  _CardForIssueOrReceiveState createState() => _CardForIssueOrReceiveState();
}

class _CardForIssueOrReceiveState extends State<CardForIssueOrReceive> {
  final _items = [];
  final GlobalKey<SliverAnimatedListState> _key = GlobalKey<SliverAnimatedListState>();
  Timer? timer;

  void _addItem(Map item) {
    _items.insert(0, item);
    _key.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
  }

  void _removeItem(int index) {
    _key.currentState!.removeItem(index, (_, animation) {
      return FadeTransition(
        opacity: animation,
        child: const Card(
          child: ListTile(
            leading: Icon(Icons.close),
            title: Text('Карта успешно выдана', style: TextStyle(fontSize: 24)),
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 300));
    _items.removeAt(index);
  }

  void removeAll() {
    for (var i = 0; i <= _items.length - 1; i++) {
      _key.currentState!.removeItem(0, (BuildContext context, Animation<double> animation) => Container());
    }
    _items.clear();
  }

  Future onRefresh() async {
    var resp = await getCardForIssueOrReceive();
    removeAll();
    resp.forEach((element) {
      _addItem(element);
    });
    if (resp.isNotEmpty) return Future.value();
    return Future.delayed(const Duration(seconds: 5));
  }

  void onSendData(int index) async {
    var resp = await tryChangeStatusCard(_items[index]['card_id'], 'change_status');
    if (!resp) return;
    _removeItem(index);
    if (_items.isEmpty) Timer(const Duration(milliseconds: 300), () => Navigator.pop(context));
  }

  @override
  void initState() {
    super.initState();
    getCardForIssueOrReceive().then((value) {
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
          const SliverAppBar(
            expandedHeight: 50.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Карты для выдачи'),
              background: FlutterLogo(),
            ),
          ),
          SliverAnimatedList(
            key: _key,
            initialItemCount: 0,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) => SizeTransition(
              sizeFactor: animation,
              child: Card(
                child: ListTile(
                  title: Text(
                      _items[index]['account']['full_name'].trim().isNotEmpty
                          ? _items[index]['account']['full_name']
                          : _items[index]['account']['username'],
                      style: const TextStyle(fontSize: 24)),
                  subtitle: Text(_items[index]['card_id'], style: const TextStyle(fontSize: 24)),
                  trailing: _items[index]['status'] == 'issue'
                      ? const Icon(Icons.arrow_upward, color: Colors.green)
                      : const Icon(Icons.arrow_downward, color: Colors.red),
                  onLongPress: () => onSendData(index),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
