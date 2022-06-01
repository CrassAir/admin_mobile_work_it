import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';

const notificationDuration = Duration(seconds: 3);
late Timer timer;

void loadingSnack() {
  if (Get.isSnackbarOpen) {
    return;
  }
  Future.delayed(Duration.zero, () {
    Get.snackbar('', '',
        titleText: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Loading...',
              style: TextStyle(fontSize: 28),
            ),
            const CircularProgressIndicator()
          ],
        ),
        animationDuration: const Duration(milliseconds: 500),
        duration: const Duration(minutes: 1));
  });
}

void messageSnack({required String title, required bool isSuccess, String? sub}) {
  Get.snackbar(
    title,
    sub ?? '',
    animationDuration: const Duration(milliseconds: 500),
    backgroundColor: isSuccess ? Colors.green : Colors.red,
    dismissDirection: DismissDirection.startToEnd,
    duration: notificationDuration,
  );
}

// void messageFailSnack({required String title, String? sub}) {
//   Future.delayed(Duration.zero, () {
//     Get.snackbar(
//       title,
//       sub ?? '',
//       animationDuration: const Duration(milliseconds: 500),
//       backgroundColor: Colors.red,
//       dismissDirection: DismissDirection.startToEnd,
//       duration: notificationDuration,
//     );
//   });
// }

// OverlaySupportEntry showLoadingDialog() {
//   return showSimpleNotification(
//       Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: const [
//           Text(
//             'Загрузка',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(width: 30),
//           CircularProgressIndicator()
//         ],
//       ),
//       background: Colors.black38,
//       duration: const Duration(hours: 1),
//       position: NotificationPosition.top);
// }
//
// void showSuccessDialog(String text) {
//   showSimpleNotification(
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.check_circle_outline, color: Colors.white),
//           const SizedBox(width: 10),
//           Flexible(
//             child: Text(
//               text,
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//       background: Colors.green,
//       slideDismissDirection: DismissDirection.startToEnd,
//       duration: notificationDuration,
//       position: NotificationPosition.top);
// }
//
// void showErrorDialog(String text) {
//   showSimpleNotification(
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, color: Colors.white),
//           const SizedBox(width: 10),
//           Text(
//             text,
//             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//       background: Colors.red,
//       slideDismissDirection: DismissDirection.startToEnd,
//       duration: notificationDuration,
//       position: NotificationPosition.top);
// }

String tagTransform(NfcTag tag) {
  List<int> rawData = tag.data['nfca']['identifier'];
  var identifier = '';
  for (var el in rawData.reversed) {
    var rad = el.toRadixString(16);
    if (el < 16) {
      rad = '0' + rad;
    }
    identifier = identifier + rad;
  }
  identifier = int.tryParse(identifier, radix: 16).toString();
  if (rawData.length > 4) {
    identifier = identifier.substring(0, identifier.length - 2) + '00';
  }
  return identifier;
}

String tagOldTransformSN(NfcTag tag) {
  List rawData = tag.data['nfca']['identifier'];
  var serial = '${rawData[2].toRadixString(16)}';
  var number = '${rawData[1].toRadixString(16)}${rawData[0].toRadixString(16)}';
  serial = int.tryParse(serial, radix: 16).toString();
  number = int.tryParse(number, radix: 16).toString();
  var identifier = '$serial/$number';
  return identifier;
}

String tagOldTransformFull(NfcTag tag) {
  List rawData = tag.data['nfca']['identifier'];
  var identifier = '${rawData[2].toRadixString(16)}${rawData[1].toRadixString(16)}${rawData[0].toRadixString(16)}';
  identifier = int.tryParse(identifier, radix: 16).toString();
  return identifier;
}

String tagGetPassword(NfcTag tag) {
  List<int> rawData = tag.data['nfca']['identifier'];
  var password = '';
  for (var el in rawData) {
    password = password + el.toRadixString(16);
  }
  password = int.tryParse(password, radix: 16).toString();
  return password;
}
