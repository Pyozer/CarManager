import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'model/car_location.model.dart';

class CarLocationPickerViewArguments {
  final CarLocation? initialCarLocation;

  CarLocationPickerViewArguments({this.initialCarLocation});
}

class CarLocationPickerView extends StatefulWidget {
  final CarLocation? initialCarLocation;

  const CarLocationPickerView({Key? key, this.initialCarLocation})
      : super(key: key);

  static const routeName = '/car_location_picker';

  @override
  State<CarLocationPickerView> createState() => _CarLocationPickerViewState();
}

class _CarLocationPickerViewState extends State<CarLocationPickerView> {
  late final TextEditingController _searchController;
  late CameraPosition _currentCameraPosition;
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    _currentCameraPosition = CameraPosition(
      target: widget.initialCarLocation?.position ?? const LatLng(48.52, 2.19),
      zoom: widget.initialCarLocation != null ? 9 : 6,
    );
    _searchController = TextEditingController(
      text: widget.initialCarLocation?.address,
    );
  }

  Future<void> _onSubmit() async {
    Navigator.of(context).pop(
      CarLocation(
        address: _searchController.text,
        position: _currentCameraPosition.target,
      ),
    );
  }

  Future<void> _onAddressSelected(String address) async {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      final location = locations.first;

      _controller!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 15,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onSubmit,
        icon: const Icon(Icons.check),
        label: const Text('Set here'),
      ),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        // The search area here
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                _onAddressSelected(_searchController.text);
              },
              icon: const Icon(Icons.search, color: Colors.white),
            ),
            hintText: 'Address here...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              onMapCreated: (controller) {
                _controller = controller;
              },
              zoomControlsEnabled: true,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              initialCameraPosition: _currentCameraPosition,
              onCameraMove: (cameraPosition) {
                _currentCameraPosition = cameraPosition;
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: SvgPicture.asset(
                'assets/images/marker.svg',
                width: 30.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
