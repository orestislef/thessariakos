import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:thessariakos/API/api.dart';
import 'package:thessariakos/helpers/device_id_helper.dart';
import 'package:thessariakos/helpers/location_helper.dart';
import 'package:thessariakos/widgets/map_view.dart';

class AddPostForm extends StatefulWidget {
  const AddPostForm({super.key});

  @override
  State<AddPostForm> createState() => _AddPostFormState();
}

class _AddPostFormState extends State<AddPostForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool shareLocation = true; // Default to true (enabled)
  bool isLocationServicesEnabled = false;

  bool isSending = false;

  @override
  void initState() {
    _checkLocationServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_post'.tr()),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 8.0),
              Text(
                'add_post_hint'.tr(),
                style: const TextStyle(fontSize: 14.0),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: titleController,
                maxLines: 3,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'title'.tr()),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: descriptionController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'description'.tr()),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),
              isLocationServicesEnabled
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Checkbox(
                          value: shareLocation,
                          onChanged: (value) {
                            setState(() {
                              shareLocation = value!;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            'share_current_location'.tr(),
                            overflow: TextOverflow
                                .ellipsis, // Added to handle overflow
                          ),
                        ),
                        IconButton(
                          onPressed: () => showCurrentLocation(),
                          icon: const Icon(Icons.map_rounded, size: 40.0),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(height: 16.0),
              isSending
                  ? const LinearProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        _savePost();
                      },
                      child: Text('submit_post'.tr()),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _savePost() async {
    String title = titleController.text;
    String description = descriptionController.text;

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${'title'.tr()} ${'is_empty_m'.tr()}'),
        duration: const Duration(seconds: 2),
      ));
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${'description'.tr()} ${'is_empty_f'.tr()}'),
        duration: const Duration(seconds: 2),
      ));
      return;
    }

    bool isOk = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('warning'.tr()),
              content: Text('post_submitted_confirmation'.tr()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'cancel'.tr(),
                  ),
                ), // Cancel button
                TextButton(
                    child: Text('ok'.tr()),
                    onPressed: () {
                      Navigator.pop(context, true);
                    })
              ]);
        });

    if (!isOk) {
      return;
    }
    setState(() {
      isSending = true;
    });

    LatLng latLng = const LatLng(0.0, 0.0);

    if (shareLocation) {
      Position? position = await LocationHelper.getCurrentLocation();
      if (position != null) {
        latLng = LatLng(position.latitude, position.longitude);
      }
    }

    String uniqueId = await DeviceIdHelper.getDeviceId();
    while (uniqueId.isEmpty) {
      uniqueId = await DeviceIdHelper.getDeviceId();
    }

    bool success = await Api.createPost(
      title: title,
      description: description,
      locationLat: latLng.latitude,
      locationLng: latLng.longitude,
      fromUser: uniqueId,
    );

    setState(() {
      isSending = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('post_submitted_success'.tr()),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('post_submitted_failure'.tr()),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    Navigator.pop(context);
  }

  void showCurrentLocation() async {
    if (isLocationServicesEnabled) {
      Position? position = await LocationHelper.getCurrentLocation();
      if (position == null) {
        return;
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      await showModalBottomSheet(
        showDragHandle: true,
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            child: MapView(latLng: latLng),
            height: 300,
            width: double.infinity,
          );
        },
      );
    } else {
      // Handle case where location services are not enabled
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('location_services_disabled'.tr()),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _checkLocationServices() {
    LocationHelper.isLocationServiceEnabled().then((isEnabled) {
      setState(() {
        isLocationServicesEnabled = isEnabled;
      });
    });
  }
}
