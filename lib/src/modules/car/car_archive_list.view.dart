import 'package:flutter/material.dart';

import 'widget/car_card.widget.dart';
import '../settings/settings.controller.dart';

class CarArchiveListView extends StatelessWidget {
  final SettingsController controller;

  const CarArchiveListView({Key? key, required this.controller})
      : super(key: key);

  static const routeName = '/archives';

  @override
  Widget build(BuildContext context) {
    final carsSaved =
        controller.carsSaved.where((car) => car.isArchive).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Archives',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 82),
        itemCount: carsSaved.length,
        itemBuilder: (BuildContext context, int index) {
          return CarCard(car: carsSaved[index]);
        },
      ),
    );
  }
}
