import 'package:admin_mobile_work_it/service/utils.dart';
import 'package:admin_mobile_work_it/store/actions/card_actions.dart';
import 'package:admin_mobile_work_it/store/models.dart';
import 'package:get/get.dart';

class CardCtrl extends GetxController {
  final CardActions cardActions = Get.put(CardActions());
  RxList<Door> doors = <Door>[].obs;

  void getDoors() async {
    Response resp = await cardActions.getDoors();
    if (resp.statusCode == 200 && resp.body is List) {
      doors.value = resp.body.map<Door>((door) => Door.fromJson(door)).toList();
      doors.refresh();
    }
  }

  void openDoor(int door_id, int perco_id, String action) async {
    Response resp = await cardActions.openDoor(door_id, perco_id, action);
    print(resp.statusCode);
    if (resp.statusCode == 200) {
      messageSnack(title: 'Дверь успешно открыта', isSuccess: true);
    }
  }
}