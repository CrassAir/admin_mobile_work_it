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
  final _items = [];


  void _addItem(String item) {
    if (!_items.contains(item)) {
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

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var identifier = tagTransform(tag);
      _addItem(identifier);
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
              onTap: () async {
                if (_items.isEmpty) return;
                var resp = await sendNewCards(_items, 'object_card');
                if (resp) Navigator.pop(context);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.home_work),
              label: 'Добавить для локаций',
              onTap: () async {
                if (_items.isEmpty) return;
                var resp = await sendNewCards(_items, 'location_card');
                if (resp) Navigator.pop(context);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.accessibility),
              label: 'Добавить для пользователей',
              onTap: () async {
                if (_items.isEmpty) return;
                var resp = await sendNewCards(_items, 'user_card');
                if (resp) Navigator.pop(context);
              },
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
                    title: Text(_items[index], style: const TextStyle(fontSize: 24)),
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

