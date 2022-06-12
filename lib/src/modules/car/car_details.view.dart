import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/string.extension.dart';
import '../../widgets/return_button.widget.dart';
import '../settings/settings.controller.dart';
import 'car_add.view.dart';
import 'model/car.model.dart';
import 'widget/car_detail_info.widget.dart';
import 'widget/car_gallery.widget.dart';
import 'widget/car_sold.widget.dart';

class CarDetailsViewArguments {
  final String carUUID;

  CarDetailsViewArguments({required this.carUUID});
}

class CarDetailsView extends StatelessWidget {
  final SettingsController controller;
  final String carUUID;

  const CarDetailsView(
      {Key? key, required this.controller, required this.carUUID})
      : super(key: key);

  static const routeName = '/car_detail';

  Future<void> _onEdit(BuildContext context, Car car) {
    return Navigator.of(context).pushNamed(
      CarAddView.routeName,
      arguments: CarAddViewArguments(baseCar: car),
    );
  }

  Future<void> _onArchive(Car car) async {
    car.isArchive = !car.isArchive;
    await controller.updateCar(car);
  }

  Widget _buildContent({
    String? title1,
    String? content1,
    String? title2,
    String? content2,
  }) {
    if ((title1 != null && content1 != null) ||
        (title2 != null && content2 != null)) {
      int flex1 = ((content1?.length ?? 1) / (content2?.length ?? 1)).round();
      int flex2 = ((content2?.length ?? 1) / (content1?.length ?? 1)).round();

      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Row(
          children: [
            if (title1 != null && content1 != null)
              Expanded(
                flex: flex1,
                child: CarDetailInfo(
                  title: title1,
                  content: content1,
                ),
              ),
            if (title2 != null && content2 != null) const SizedBox(width: 12),
            if (title2 != null && content2 != null)
              Expanded(
                flex: flex2,
                child: CarDetailInfo(
                  title: title2,
                  content: content2,
                ),
              ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final car = controller.carsSaved.firstWhere((car) => car.uuid == carUUID);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => launchUrlString(car.adUrl),
        child: const Icon(Icons.visibility),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 124),
        children: [
          Stack(
            children: [
              CarGallery(imagesUrl: car.imagesUrl),
              const ReturnButton(),
            ],
          ),
          if (car.isSold) const CarSold(),
          Padding(
            padding: const EdgeInsets.fromLTRB(13.0, 13.0, 13.0, 2.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                    onPressed: () => _onEdit(context, car),
                  ),
                ),
                const SizedBox(width: 18.0),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: car.isArchive
                        ? const Icon(Icons.restore)
                        : const Icon(Icons.archive_outlined),
                    label: car.isArchive
                        ? const Text('Restore')
                        : const Text('Archive'),
                    onPressed: () => _onArchive(car),
                  ),
                ),
              ],
            ),
          ),
          _buildContent(
            title1: 'Titre',
            content1: car.title,
          ),
          _buildContent(
            title1: 'Date immatriculation',
            content1: car.displayDate,
            title2: 'Kilomètrage',
            content2: car.displayKMs,
          ),
          _buildContent(
            title1: 'Plaque',
            content1: car.plate,
            title2: 'VIN',
            content2: car.vin,
          ),
          _buildContent(
            title1: 'Puissance',
            content1: '${car.hp} HP',
            title2: 'Prix',
            content2: car.displayPrice,
          ),
          _buildContent(
            title1: 'Description',
            content1: car.description,
          ),
          _buildContent(
            title1: 'Ajouté le',
            content1: DateFormat.yMMMMEEEEd(
                    Localizations.localeOf(context).languageCode)
                .format(car.adDate)
                .capitalize(),
          ),
        ],
      ),
    );
  }
}
