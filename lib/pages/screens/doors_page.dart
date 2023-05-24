import 'package:admin_mobile_work_it/store/controllers/card_ctrl.dart';
import 'package:admin_mobile_work_it/store/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoorsPage extends StatefulWidget {
  const DoorsPage({Key? key}) : super(key: key);

  @override
  State<DoorsPage> createState() => _DoorsPageState();
}

class _DoorsPageState extends State<DoorsPage> {
  final CardCtrl cardCtrl = Get.put(CardCtrl());

  @override
  void initState() {
    super.initState();
    cardCtrl.getDoors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 50.0,
            backgroundColor: Theme.of(context).canvasColor,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Двери', style: Theme.of(context).textTheme.titleLarge,),
            ),
          ),
          Obx(
            () => SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                Door door = cardCtrl.doors[index];
                return Card(
                    child: ListTile(
                  title: Text(door.get_name()),
                  onTap: () => cardCtrl.openDoor(door.id, door.perco_id, 'in'),
                ));
              }, childCount: cardCtrl.doors.length),
            ),
          ),
        ],
      ),
    );
  }
}
