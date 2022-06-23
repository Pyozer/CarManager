import 'package:google_maps_flutter/google_maps_flutter.dart';

class CarLocation {
  final String address;
  final LatLng position;

  const CarLocation({required this.address, required this.position});

  factory CarLocation.fromJson(dynamic data) {
    return CarLocation(
      address: data['address'],
      position: LatLng.fromJson(data['position'])!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'position': position.toJson(),
    };
  }
}
