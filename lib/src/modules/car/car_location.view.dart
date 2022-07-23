import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'model/car_location.model.dart';

class CarLocationViewArguments {
  final CarLocation location;

  CarLocationViewArguments({required this.location});
}

class CarLocationView extends StatefulWidget {
  final CarLocation location;

  const CarLocationView({Key? key, required this.location}) : super(key: key);

  static const routeName = '/car_location';

  @override
  State<CarLocationView> createState() => _CarLocationViewState();
}

class _CarLocationViewState extends State<CarLocationView> {
  Future<void> _openDirection(String address) async {
    String appleUrl =
        'https://maps.apple.com/?saddr=&daddr=${Uri.encodeComponent(address)}&directionsmode=driving';
    String googleUrl =
        'https://www.google.com/maps/dir//${Uri.encodeComponent(address)}';

    if (Platform.isIOS && await canLaunchUrlString(appleUrl)) {
      await launchUrlString(appleUrl);
    } else if (await canLaunchUrlString(googleUrl)) {
      await launchUrlString(googleUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(translate.location),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: translate.openItinaryTooltip,
        onPressed: () {
          _openDirection(widget.location.address);
        },
        child: const Icon(Icons.directions),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
          target: widget.location.position,
          zoom: 8,
        ),
        markers: {
          Marker(
            markerId: MarkerId(widget.location.address),
            position: widget.location.position,
            infoWindow: InfoWindow(
              title: widget.location.address,
            ),
          ),
        },
      ),
    );
  }
}
