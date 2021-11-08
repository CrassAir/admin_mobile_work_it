import 'package:admin_mobile_work_it/service/api.dart';
import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({Key? key}) : super(key: key);

  @override
  _AddNewCardState createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  final GlobalKey<SliverAnimatedListState> _key = GlobalKey<SliverAnimatedListState>();
  final List<Map<String, String>> _items = [];


  void _addItem(Map<String, String> item) {
    if (!_items.any((val) => val['card_id'] == item['card_id'])) {
      _items.insert(0, item);
      _key.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
    }
  }

  void _removeItem(int index) {
    _key.currentState!.removeItem(index, (_, animation) {
      return FadeTransition(
        opacity: animation,
        child: const Card(
          child: ListTile(
            leading: Icon(Icons.close),
            title: Text('Goodbye', style: TextStyle(fontSize: 24)),
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 300));

    _items.removeAt(index);
  }

  void sendCards(String type) async {
    if (_items.isEmpty) {
      showErrorDialog('Нельзя отправить пустой список карт');
      return;
    }
    var resp = await sendNewCards(_items, type);
    if (resp) Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var identifier = tagTransform(tag);
      var SN = tagOldTransformSN(tag);
      var oldFull = tagOldTransformFull(tag);
      var password = tagGetPassword(tag);
      _addItem({'card_id': identifier, 'old_card_id_w_sn': SN, 'old_card_id_full': oldFull, 'password': password});
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
      floatingActionButton: SpeedDial(
          overlayColor: Colors.black12,
          backgroundColor: Colors.lightBlueAccent,
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 3,
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          renderOverlay: true,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.computer),
              label: 'Добавить для объектов',
              onTap: () => sendCards('object_card'),
            ),
            SpeedDialChild(
              child: const Icon(Icons.home_work),
              label: 'Добавить для локаций',
              onTap: () => sendCards('location_card'),
            ),
            SpeedDialChild(
              child: const Icon(Icons.accessibility),
              label: 'Добавить для пользователей',
              onTap: () => sendCards('user_card'),
            ),
          ]),
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            expandedHeight: 50.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Новые карточки'),
              background: FlutterLogo(),
            ),
          ),
          SliverAnimatedList(
            key: _key,
            initialItemCount: 0,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) => SizeTransition(
              key: UniqueKey(),
              sizeFactor: animation,
              child: Slidable(
                actionPane: const SlidableDrawerActionPane(),
                // actionExtentRatio: 0.25,
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () => _removeItem(index),
                  ),
                ],
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.credit_card_sharp),
                    title: Text(_items[index]['card_id']!, style: const TextStyle(fontSize: 24)),
                    subtitle: Text('${_items[index]['old_card_id_w_sn']!} <-> ${_items[index]['old_card_id_full']!}'),
                    onLongPress: () => _removeItem(index),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

