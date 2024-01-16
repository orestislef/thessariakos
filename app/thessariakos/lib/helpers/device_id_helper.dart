import 'dart:html' as html;
import 'dart:io' show Platform;
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';

class DeviceIdHelper {
  static Future<String> getDeviceId() async {
    String deviceId = '';

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (kIsWeb) {
        deviceId = await _getWebDeviceId();
      } else if (Platform.isAndroid) {
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

  static Future<String> _getWebDeviceId() async {
    const key = 'uniqueId';
    var storedId = html.window.localStorage[key];

    if (storedId == null) {
      storedId = _generateRandomId();
      html.window.localStorage[key] = storedId;
    }

    return storedId;
  }

  static String _generateRandomId() {
    final random = Random();

    // Generate a random number with characters inserted
    String generateRandomNumberWithChars() {
      final randomNumber = random.nextInt(999999);
      final char = String.fromCharCode(random.nextInt(26) + 65);
      final indexToInsertChar = random.nextInt(6);

      final numberString = randomNumber.toString();
      final modifiedNumberString =
          '${numberString.substring(0, indexToInsertChar)}$char${numberString.substring(indexToInsertChar)}';

      return modifiedNumberString;
    }

    final id =
        '${generateRandomNumberWithChars()}-${generateRandomNumberWithChars()}';
    return id;
  }
}
