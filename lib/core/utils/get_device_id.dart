import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

Future<Map<String, dynamic>> getDeviceId() async {
  DeviceInfoPlugin infoPlugin = DeviceInfoPlugin();
  // final info = await infoPlugin.deviceInfo;
  // return info.data;
  if (kIsWeb) {
    var web = await infoPlugin.webBrowserInfo;
    return web.data;
  }
  if (Platform.isAndroid) {
    var androidInfo = await infoPlugin.androidInfo;
    return androidInfo.data;
  } else if (Platform.isIOS) {
    var iosInfo = await infoPlugin.iosInfo;
    return iosInfo.data;
  } else if (Platform.isWindows) {
    var androidInfo = await infoPlugin.windowsInfo;
    return androidInfo.data;
  } else if (Platform.isLinux) {
    var iosInfo = await infoPlugin.linuxInfo;
    return iosInfo.data;
  } else if (Platform.isMacOS) {
    var iosInfo = await infoPlugin.macOsInfo;
    return iosInfo.data;
  } else {
    var iosInfo = await infoPlugin.deviceInfo;
    return iosInfo.data;
  }
}

Future<Map<String, dynamic>> getDeviceInfo() async {
  DeviceInfoPlugin infoPlugin = DeviceInfoPlugin();
  final info = await infoPlugin.deviceInfo;
  Map<String, dynamic> output = <String, dynamic>{};
  info.data.forEach((key, value) {
    output[key] = value.toString();
  });
  return output;
}
