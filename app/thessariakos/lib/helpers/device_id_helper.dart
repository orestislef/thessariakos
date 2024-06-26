import 'package:flutter/foundation.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const String webDeviceIdKey = 'webDeviceId';

class DeviceIdHelper {
  static Future<String> getDeviceId() async {
    if (kIsWeb) {
      String deviceId = await _getWebDeviceId();
      return deviceId;
    } else {
      String deviceId = await PlatformDeviceId.getDeviceId ?? 'unknown';
      return deviceId;
    }
  }

  static Future<String> _getWebDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedDeviceId = prefs.getString(webDeviceIdKey) ?? '';

    if (storedDeviceId.isNotEmpty) {
      return storedDeviceId;
    } else {
      var uuid = const Uuid();
      String webDeviceId = uuid.v4();
      await prefs.setString(webDeviceIdKey, webDeviceId);

      return webDeviceId;
    }
  }
}
