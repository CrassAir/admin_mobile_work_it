import 'package:admin_mobile_work_it/store/api_client.dart';
import 'package:get/get.dart';


Future<void> init() async {
  // api client
  Get.lazyPut<ApiClient>(() => ApiClient());
}