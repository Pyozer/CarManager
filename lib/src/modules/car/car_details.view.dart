import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/extensions/media_query_data.extension.dart';
import '../../utils/extensions/string.extension.dart';
import '../../widgets/return_button.widget.dart';
import '../settings/settings_cars.controller.dart';
import 'car_add.view.dart';
import 'car_location.view.dart';
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

  Future<void> _onSellToggle(Car car) async {
    car.isSold = !car.isSold;
    await context.read<SettingsCarsController>().updateCar(car);
  }

  Widget _buildMap(Car car) {
    return SizedBox(
      height: 130,
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        elevation: 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: GoogleMap(
            onTap: (_) async {
              await Navigator.of(context).pushNamed(
                CarLocationView.routeName,
                arguments: CarLocationViewArguments(
                  location: car.location,
                ),
              );
            },
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            myLocationEnabled: false,
            zoomGesturesEnabled: false,
            compassEnabled: false,
            indoorViewEnabled: false,
            mapToolbarEnabled: false,
            trafficEnabled: false,
            buildingsEnabled: false,
            tiltGesturesEnabled: false,
            rotateGesturesEnabled: false,
            scrollGesturesEnabled: false,
            initialCameraPosition: CameraPosition(
              target: car.location.position,
              zoom: 8,
            ),
            markers: {
              Marker(
                markerId: MarkerId(car.uuid),
                position: car.location.position,
              ),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFooterButtons(Car car) {
    final buttonStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _onEdit(context, car),
            style: buttonStyle,
            icon: const Icon(Icons.edit_outlined),
            label: Text(AppLocalizations.of(context)!.editBtn),
          ),
        ),
        const SizedBox(width: 18.0),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _onSellToggle(car),
            style: buttonStyle,
            icon: car.isSold
                ? const Icon(Icons.restore)
                : const Icon(Icons.archive_outlined),
            label: car.isSold
                ? Text(AppLocalizations.of(context)!.toSell)
                : Text(AppLocalizations.of(context)!.sold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final car = context
        .watch<SettingsCarsController>()
        .cars
        .firstWhere((car) => car.uuid == widget.carUUID);

    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => launchUrlString(car.adUrl),
        child: const Icon(Icons.visibility),
      ),
      body: Theme(
        data: theme.copyWith(
          dividerColor: Colors.transparent,
          textTheme: theme.textTheme.copyWith(
            titleMedium: GoogleFonts.oswald(
              textStyle: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            headlineSmall: theme.textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        child: Builder(builder: (context) {
          return ListView(
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(car.make.name.toUpperCase()),
                    const SizedBox(height: 8.0),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 16.0,
                      children: [
                        Text(
                          car.model.toUpperCase(),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          car.displayPrice,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 10.0,
                      children: [
                        Chip(label: Text(car.displayKMs)),
                        Chip(label: Text('${car.hp} HP')),
                        Chip(label: Text(car.displayDate)),
                        Chip(label: Text(car.handDrive.name)),
                      ],
                    ),
                  ],
                ),
              ),
              ExpansionTile(
                initiallyExpanded: true,
                expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                childrenPadding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 8.0,
                ),
                title: Text(
                  AppLocalizations.of(context)!.overview.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                iconColor: Theme.of(context).colorScheme.onSurface,
                children: [
                  Text(car.description),
                ],
              ),
              CarDetailInfo(
                title: AppLocalizations.of(context)!.location.toUpperCase(),
                copyableText: car.location.address,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(car.location.address.trim().capitalize()),
                    const SizedBox(height: 12.0),
                    _buildMap(car),
                  ],
                ),
              ),
              if (car.plate?.isNotEmpty ?? false)
                CarDetailInfo(
                  title: AppLocalizations.of(context)!.plate.toUpperCase(),
                  copyableText: car.plate,
                  child: Text(car.plate!),
                ),
              if (car.vin?.isNotEmpty ?? false)
                CarDetailInfo(
                  title: AppLocalizations.of(context)!.vin.toUpperCase(),
                  copyableText: car.vin,
                  child: Text(car.vin!),
                ),
              CarDetailInfo(
                title: AppLocalizations.of(context)!.addedAt.toUpperCase(),
                child: Text(
                  DateFormat.yMMMMEEEEd(
                    Localizations.localeOf(context).languageCode,
                  ).format(car.adDate).capitalize(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(13.0, 13.0, 13.0, 2.0),
                child: _buildFooterButtons(car),
              ),
            ],
          );
        }),
      ),
    );
  }
}
