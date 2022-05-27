import 'dart:async';
import 'package:admin_mobile_work_it/models/models.dart';
import 'package:admin_mobile_work_it/screens/set_user_photo.dart';
import 'package:admin_mobile_work_it/service/api.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailUser extends StatefulWidget {
  const DetailUser({Key? key, required this.user, required this.newCard}) : super(key: key);
  final User user;
  final Map? newCard;

  @override
  State<DetailUser> createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
  final GlobalKey<SliverAnimatedListState> _key = GlobalKey<SliverAnimatedListState>();

  void onChangeUserCard(String username) async {
    var resp = await tryChangeUserCard(username, newCard: widget.newCard);
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
        }).whenComplete(() => Timer(const Duration(milliseconds: 300), () => Navigator.pushReplacementNamed(context, '/')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      const SliverAppBar(
        expandedHeight: 50.0,
        flexibleSpace: FlexibleSpaceBar(
          title: Text('Профиль'),
          background: FlutterLogo(),
        ),
      ),
      SliverAnimatedList(
        key: _key,
        initialItemCount: 1,
        itemBuilder: (BuildContext context, int index, Animation<double> animation) => Card(
          child: Column(children: [
            Center(
              child: OpenContainer(
                  openColor: Theme.of(context).cardColor,
                  closedColor: Theme.of(context).cardColor,
                  closedBuilder: (context, action) {
                    return CircleAvatar(
                      radius: 200,
                      backgroundColor: Colors.brown.shade800,
                      child: const Text('AH'),
                    );
                  },
                  openBuilder: (context, action) => SetUserPhoto()),
            ),
            Text(widget.user.full_name!.trim().isNotEmpty ? widget.user.full_name! : widget.user.username!,
                style: const TextStyle(fontSize: 40)),
            Text(widget.newCard != null ? 'Карточка для замены -> ${widget.newCard?['card_id']}' : '',
                style: const TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () => onChangeUserCard(widget.user.username!), child: const Text('Поменять карту'))),
                Container(
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: () =>
                            tryFireUser(widget.user.username!),
                        child: const Text('Уволить сотрудника'))),
              ],
            )
          ]),
        ),
      )
    ]));
  }
}
