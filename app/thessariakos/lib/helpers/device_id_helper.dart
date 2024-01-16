import 'dart:io' show Platform;

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';

class DeviceIdHelper {
  static Future<String> getDeviceId() async {
    String deviceId = '';

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        deviceId = await _getAndroidDeviceId(deviceInfo);
      } else if (Platform.isIOS) {
        deviceId = await _getIosDeviceId(deviceInfo);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting device ID: $e');
      }
    }

    return deviceId;
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
