import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool?> handleNotificationsPermissions() async {
  if (kIsWeb) {
    return null;
  }
  var curStatus = await Permission.notification.status;
  if ([PermissionStatus.restricted, PermissionStatus.permanentlyDenied]
      .contains(curStatus)) return null;
  if (curStatus == PermissionStatus.denied) {
    curStatus = await Permission.notification.request();
    return [PermissionStatus.granted, PermissionStatus.limited]
        .contains(curStatus);
  } else {
    return true;
  }
}
