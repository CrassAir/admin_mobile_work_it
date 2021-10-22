import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:overlay_support/overlay_support.dart';

OverlaySupportEntry showLoadingDialog() {
  return showSimpleNotification(
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'Загрузка',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 30),
          const CircularProgressIndicator()
        ],
      ),
      background: Colors.black38,
      duration: const Duration(hours: 1),
      position: NotificationPosition.top);
}

String tagTransform(NfcTag tag) {
  List<int> rawData = tag.data['mifareclassic']['identifier'];
  var identifier = '';
  rawData.reversed.forEach((el) {
    identifier = identifier + '${el.toRadixString(16)}';
  });
  identifier = int.tryParse(identifier, radix: 16).toString();
  return identifier;
}
