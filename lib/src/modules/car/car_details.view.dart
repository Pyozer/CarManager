import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/string.extension.dart';
import '../../widgets/return_button.widget.dart';
import '../settings/settings.controller.dart';
import 'widget/car_detail_info.widget.dart';
import 'widget/car_gallery.widget.dart';
import 'model/car.model.dart';

class CarDetailsViewArguments {
  final Car car;

  CarDetailsViewArguments({required this.car});
}

class CarDetailsView extends StatelessWidget {
  const CarDetailsView({Key? key, required this.controller}) : super(key: key);

  static const routeName = '/car_detail';

  final SettingsController controller;

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
        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
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
            if (title2 != null && content2 != null) const SizedBox(width: 12.0),
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
    final args =
        ModalRoute.of(context)!.settings.arguments! as CarDetailsViewArguments;
    final car = args.car;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => launchUrlString(car.adUrl),
        child: const Icon(Icons.visibility),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 124.0),
        children: [
          Stack(
            children: [
              CarGallery(imagesUrl: car.imagesUrl),
              const ReturnButton(),
            ],
          ),
          if (car.isSold)
            Material(
              elevation: 4.0,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                color: Theme.of(context).colorScheme.error,
                child: const Text(
                  'VENDU',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
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
          _buildContent(title1: 'Description', content1: car.description),
          _buildContent(
            title1: 'Ajouté le',
            content1: DateFormat.yMMMMEEEEd(
                    Localizations.localeOf(context).languageCode)
                .format(car.adDate).capitalize(),
          ),
        ],
      ),
    );
  }
}
