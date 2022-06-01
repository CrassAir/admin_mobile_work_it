import 'dart:async';
import 'package:admin_mobile_work_it/controllers/user_ctrl.dart';
import 'package:admin_mobile_work_it/screens/set_user_photo.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailUser extends StatefulWidget {
  final Map? newCard;

  const DetailUser({Key? key, required this.newCard}) : super(key: key);

  @override
  State<DetailUser> createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
  final GlobalKey<SliverAnimatedListState> _key = GlobalKey<SliverAnimatedListState>();
  final UserCtrl userCtrl = Get.find();
  String username = '';

  @override
  Widget build(BuildContext context) {
    if (userCtrl.user != null) {
      username = userCtrl.user!.full_name!.trim().isNotEmpty ? userCtrl.user!.full_name! : userCtrl.user!.username!;
    }
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
                  openBuilder: (context, action) => Scaffold(body: SetUserPhoto())),
            ),
            Text(username, style: const TextStyle(fontSize: 40)),
            Text(widget.newCard != null ? 'Карточка для замены -> ${widget.newCard?['card_id']}' : '',
                style: const TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: widget.newCard == null ? Colors.grey : Colors.green),
                        onPressed: widget.newCard == null
                            ? null
                            : () => userCtrl
                                .tryChangeUserCard(userCtrl.user!.username!, widget.newCard!)
                                .then((_) => Navigator.pop(context)),
                        child: const Text('Поменять карту'))),
                Container(
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: () => userCtrl.tryFireUser().then((_) => Navigator.pop(context)),
                        child: const Text('Уволить сотрудника'))),
              ],
            )
          ]),
        ),
      )
    ]));
  }
}
