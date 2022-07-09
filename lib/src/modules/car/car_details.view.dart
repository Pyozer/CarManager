import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/extensions/media_query_data.extension.dart';
import '../../utils/extensions/string.extension.dart';
import '../../widgets/return_button.widget.dart';
import '../settings/settings_cars.controller.dart';
import 'car_add.view.dart';
import 'model/car.model.dart';
import 'widget/car_detail_info.widget.dart';
import 'widget/car_gallery.widget.dart';
import 'widget/car_sold.widget.dart';

class CarDetailsViewArguments {
  final String carUUID;

  CarDetailsViewArguments({required this.carUUID});
}

class CarDetailsView extends StatefulWidget {
  final String carUUID;

  const CarDetailsView({Key? key, required this.carUUID}) : super(key: key);

  static const routeName = '/car_detail';

  @override
  State<CarDetailsView> createState() => _CarDetailsViewState();
}

class _CarDetailsViewState extends State<CarDetailsView> {
  Future<void> _onEdit(BuildContext context, Car car) {
    return Navigator.of(context).pushNamed(
      CarAddView.routeName,
      arguments: CarAddViewArguments(baseCar: car),
    );
  }

  Future<void> _onArchive(Car car) async {
    car.isArchive = !car.isArchive;
    await context.read<SettingsCarsController>().updateCar(car);
  }

  void _openMap(LatLng latlng) {
    final position = [latlng.latitude, latlng.longitude].join(',');

    if (Platform.isIOS) {
      launchUrl(Uri(
        scheme: 'maps',
        queryParameters: {'q': position},
      ));
    } else {
      launchUrl(Uri(scheme: 'geo', path: position));
    }
  }

  Widget _buildContent({
    String? title1,
    String? content1,
    Widget? footer1,
  }) {
    if ((title1 != null && content1 != null)) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: CarDetailInfo(
          title: title1,
          content: content1,
          footer: footer1,
        ),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final car = context
        .watch<SettingsCarsController>()
        .cars
        .firstWhere((car) => car.uuid == widget.carUUID);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => launchUrlString(car.adUrl),
        child: const Icon(Icons.visibility),
      ),
      body: ListView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).paddingAboveFAB,
        ),
        children: [
          Stack(
            children: [
              CarGallery(imagesUrl: car.imagesUrl),
              const ReturnButton(),
            ],
          ),
          if (car.isSold) const CarSold(),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(car.year.toString(),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lotus Exige',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
                ),
                Text(
                  car.displayPrice,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 10.0,
              children: [
                Chip(label: Text(car.displayKMs)),
                Chip(label: Text('${car.hp} HP')),
                Chip(label: Text(car.displayDate)),
                Chip(label: Text(car.handDrive.name)),
              ],
            ),
          ),
          _buildContent(
            title1: car.title,
            content1: car.description,
          ),
          _buildContent(
            title1: 'Location',
            content1: car.location.address
                .split(',')
                .map((e) => e.trim().capitalize())
                .join(',\n'),
            footer1: SizedBox(
              height: 165,
              child: IgnorePointer(
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: car.location.position,
                    zoom: 8,
                  ),
                  onTap: (_) => _openMap(car.location.position),
                  markers: {
                    Marker(
                      markerId: MarkerId(car.uuid),
                      position: car.location.position,
                    ),
                  },
                ),
              ),
            ),
          ),
          _buildContent(
            title1: 'Plaque',
            content1: car.plate,
          ),
          _buildContent(
            title1: 'VIN',
            content1: car.vin,
          ),
          _buildContent(
            title1: 'Ajouté le',
            content1: DateFormat.yMMMMEEEEd(
              Localizations.localeOf(context).languageCode,
            ).format(car.adDate).capitalize(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13.0, 13.0, 13.0, 2.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _onEdit(context, car),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 18.0),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _onArchive(car),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    icon: car.isArchive
                        ? const Icon(Icons.restore)
                        : const Icon(Icons.archive_outlined),
                    label: car.isArchive
                        ? const Text('Restore')
                        : const Text('Archive'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
