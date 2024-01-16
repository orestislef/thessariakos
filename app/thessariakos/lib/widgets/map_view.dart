import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:thessariakos/helpers/theme_helper.dart';

class MapView extends StatefulWidget {
  final LatLng latLng;

  const MapView({super.key, required this.latLng});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    List<Marker> markers = [
      Marker(
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40.0,
        ),
        rotate: true,
        point: widget.latLng,
        alignment: Alignment.topCenter,
      ),
    ];
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: SizedBox(
        height: 400.0,
        width: double.infinity,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: widget.latLng,
            initialZoom: 15.5,
            maxZoom: 18.0,
            minZoom: 3.0,
          ),
          mapController: MapController(),
          children: [
            TileLayer(
              urlTemplate: ThemeHelper.isDarkMode(context)
                  ? 'https://basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png' //Night mode
                  : 'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png', //Day mode
              userAgentPackageName: 'com.orestislef.thessariakos.thessariakos',
              maxZoom: 18.0,
              minZoom: 3.0,
              subdomains: const ['x', 'y', 'z'],
            ),
            MarkerLayer(markers: markers),
          ],
        ),
      ),
    );
  }
}
