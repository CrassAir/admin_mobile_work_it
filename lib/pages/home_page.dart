import 'package:admin_mobile_work_it/pages/screens/add_new_card.dart';
import 'package:admin_mobile_work_it/pages/screens/change_user_card.dart';
import 'package:admin_mobile_work_it/pages/screens/doors_page.dart';
import 'package:admin_mobile_work_it/store/controllers/account_ctrl.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> listData = [
    {'title': 'Добавить кары', 'widget': const AddNewCard()},
    {'title': 'Сотрудники', 'widget': const ChangeOrDeactivateUserCard()},
    {'title': 'Двери', 'widget': const DoorsPage()},
  ];

  var accountController = Get.find<AccountCtrl>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        expandedHeight: 50.0,
        flexibleSpace: const FlexibleSpaceBar(
          title: Text('Адмника'),
          background: FlutterLogo(),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                // case 1:
                //   vm.changeTheme(isDarkTheme: !vm.isDarkTheme);
                //   break;
                case 2:
                  accountController.logout();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              // PopupMenuItem(
              //   value: 1,
              //   child: ListTile(
              //     leading: vm.isDarkTheme ?  const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
              //     title: vm.isDarkTheme ? const Text('Light mode') : const Text('Dark mode'),
              //   ),
              // ),
              // const PopupMenuDivider(),
              const PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),
      SliverAnimatedList(
          initialItemCount: listData.length,
          itemBuilder: (BuildContext context, int index, Animation<double> animation) {
            var data = listData[index];
            var title = data['title']!;
            return Card(
              child: OpenContainer(
                  openColor: Theme.of(context).cardColor,
                  closedColor: Theme.of(context).cardColor,
                  closedBuilder: (context, action) {
                    return ListTile(
                      tileColor: Theme.of(context).cardColor,
                      title: Text(title),
                    );
                  },
                  openBuilder: (context, action) => listData[index]['widget']),
            );
          })
    ]));
  }
}
