import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thessariakos/API/api.dart';
import 'package:thessariakos/helpers/device_id_helper.dart';
import 'package:thessariakos/helpers/location_helper.dart';
import 'package:thessariakos/screens/main_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLocationEnabled = false;
  String? deviceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr()),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (deviceId != null) _buildUserInfo(),
              const SizedBox(height: 8.0),
              _buildWelcomeText(),
              isLocationEnabled
                  ? _buildConnectButton()
                  : _buildLocationPermissionButton(),
              isLocationEnabled
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: _goToMainScreen,
                          child: Text('skip_and_connect'.tr())),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToMainScreen() async {
    String uniqueId = await DeviceIdHelper.getDeviceId();
    while (uniqueId.isEmpty) {
      uniqueId = await DeviceIdHelper.getDeviceId();
    }
    Position? position = await LocationHelper.getCurrentLocation();

    LatLng latLng = LatLng(
      position?.latitude ?? 0.0,
      position?.longitude ?? 0.0,
    );

    bool isUserCreated = await Api.createUser(
      uniqueId: uniqueId,
      name: '',
      currentLocationLat: latLng.latitude,
      currentLocationLng: latLng.longitude,
    );
    if (isUserCreated) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      if (kDebugMode) {
        print('Error creating user');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error_creating_user'.tr()),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void initState() {
    _checkLocationPermission();
    _getDeviceId();
    super.initState();
  }

  void _checkLocationPermission() {
    LocationHelper.isLocationPermissionGranted().then((isGranted) {
      if (isGranted) {
        setState(() {
          isLocationEnabled = isGranted;
        });
      }
    });
  }

  Widget _buildLocationPermissionButton() {
    return ElevatedButton(
        onPressed: () {
          LocationHelper.showLocationDialog(context, () {
            Navigator.of(context).pop();
            _checkLocationPermission();
          });
        },
        child: Text('enable_gps'.tr()));
  }

  Widget _buildWelcomeText() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[300]!,
      child: Text(
        '${'welcome_to'.tr()} ${'app_name'.tr()}',
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildConnectButton() {
    return ElevatedButton(
      onPressed: _goToMainScreen,
      child: Text('connect'.tr()),
    );
  }

  void _getDeviceId() {
    DeviceIdHelper.getDeviceId().then((value) {
      if (value.isEmpty) {
        _getDeviceId();
        return;
      }
      setState(() {
        deviceId = value;
      });
    });
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        SelectableText.rich(
          TextSpan(
            text: '${'device_id'.tr()}: ',
            style: const TextStyle(color: Colors.grey),
            children: [
              TextSpan(
                text: deviceId,
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8.0),
        !isLocationEnabled
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('welcome_text'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14.0)),
              )
            : const SizedBox(),
      ],
    );
  }
}
