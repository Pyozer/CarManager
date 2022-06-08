import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'model/car.model.dart';
import '../settings/settings.controller.dart';
import '../../widgets/banner_toggle.widget.dart';
import 'widget/car_detail_info.widget.dart';
import 'widget/car_gallery.widget.dart';

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
      appBar: AppBar(
        title: Text(car.title, overflow: TextOverflow.fade),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Add delete action
            },
            color: Theme.of(context).colorScheme.onPrimary,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => launchUrlString(car.adUrl),
        child: const Icon(Icons.visibility),
      ),
      body: BannerToggle(
        display: car.isSold,
        message: 'VENDU',
        location: BannerLocation.topEnd,
        color: Colors.red,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 124.0),
          children: [
            CarGallery(imagesUrl: car.imagesUrl),
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
            _buildContent(title1: 'Prix', content1: car.displayPrice),
            _buildContent(title1: 'Description', content1: car.description),
          ],
        ),
      ),
    );
  }
}
