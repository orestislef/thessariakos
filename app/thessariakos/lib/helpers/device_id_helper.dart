import 'dart:io' show Platform;

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:platform_device_id/platform_device_id.dart';

class DeviceIdHelper {
  static Future<String> getDeviceId() async {
    if (kIsWeb) {
      String? deviceId = await PlatformDeviceId.getDeviceId;
      return deviceId ?? 'web';
    }

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      String deviceId = await _getAndroidDeviceId(deviceInfo);
      return deviceId;
    } else if (Platform.isIOS) {
      String deviceId = await _getIosDeviceId(deviceInfo);
      return deviceId;
    }

    return 'unknown';
  }

  static Future<String> _getAndroidDeviceId(DeviceInfoPlugin deviceInfo) async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.androidId;
  }

  static Future<String> _getIosDeviceId(DeviceInfoPlugin deviceInfo) async {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor;
  }
}
