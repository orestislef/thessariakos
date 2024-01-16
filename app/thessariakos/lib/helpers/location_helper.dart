import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return null;
      }
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
      timeLimit: const Duration(seconds: 10),
    );
    return position;
  }

  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<bool> isLocationPermissionGranted() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever &&
        permission != LocationPermission.unableToDetermine;
  }

  static Future<void> showLocationDialog(
      BuildContext context, VoidCallback onOk) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('warning'.tr()),
          content:
              Text('${'location_services_disabled'.tr()} ${'app_name'.tr()}'),
          actions: [
            TextButton(
              onPressed: () {
                Geolocator.requestPermission().then((value) {
                  onOk.call();
                });
              },
              child: Text('ok'.tr()),
            ),
          ],
        );
      },
    );
  }
}
