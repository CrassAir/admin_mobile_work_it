import 'package:admin_mobile_work_it/models/view_models.dart';
import 'package:admin_mobile_work_it/service/redux.dart';
import 'package:animations/animations.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'add_new_card.dart';
import 'change_user_card.dart';

class HomePage extends StatefulWidget {
  final Function updateState;
  const HomePage({Key? key, required this.updateState}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> listData = [
    {'title': 'Добавить каротчки', 'widget': const AddNewCard()},
    {'title': 'Заменить карточку сотруднику', 'widget': const ChangeUserCard()}
  ];

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      vm: () => Factory(this),
      builder: (BuildContext context, ViewModel vm) {
        return Scaffold(
          body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 50.0,
          flexibleSpace: const FlexibleSpaceBar(
            title: Text('Адмника'),
            background: FlutterLogo(),
          ),
          actions: [
            IconButton(
              onPressed: () {
                vm.changeAuth(isAuth: false);
                widget.updateState();
                },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        SliverAnimatedList(
            initialItemCount: listData.length,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) {
              var data = listData[index];
              var title = data['title']!;
              return Card(
                child: OpenContainer(
                    closedBuilder: (context, action) {
                      return ListTile(
                        title: Text(title),
                      );
                    },
                    openBuilder: (context, action) => listData[index]['widget']),
              );
            })
      ])
          // bottomNavigationBar: BottomNavyBar(
          //   selectedIndex: _selectedIndex,
          //   showElevation: true,
          //   itemCornerRadius: 24,
          //   // backgroundColor: Colors.white,
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   onItemSelected: (index) => setState(() => _selectedIndex = index),
          //   items: [
          //     BottomNavyBarItem(
          //       title: const Text('Задачи'),
          //       icon: const Icon(Icons.dashboard),
          //       textAlign: TextAlign.center,
          //       activeColor: Colors.blue,
          //       inactiveColor: Colors.grey,
          //     ),
          //     BottomNavyBarItem(
          //       title: const Text('Помощь'),
          //       icon: const Icon(Icons.help_center),
          //       textAlign: TextAlign.center,
          //       activeColor: Colors.blue,
          //       inactiveColor: Colors.grey,
          //     ),
          //   ],
          // ),
          );},
    );
  }
}
