import 'package:admin_mobile_work_it/store/api_client.dart';
import 'package:get/get.dart';

class CardActions extends GetxService {
  final ApiClient apiClient = Get.find();

  CardActions();

  Future<Response> getDoors() async {
    Response resp = await apiClient.getData('/api/door/');
    return resp;
  }

  Future<Response> openDoor(int door_id, int perco_id, String action) async {
    Response resp = await apiClient.postData(
        '/api/door/${door_id.toString()}/try_open_door/', {'perco_id': perco_id.toString(), 'action': action});
    return resp;
  }
}
