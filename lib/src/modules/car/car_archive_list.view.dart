import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings/settings_cars.controller.dart';
import 'widget/car_card.widget.dart';

class CarArchiveListView extends StatelessWidget {
  const CarArchiveListView({Key? key}) : super(key: key);

  static const routeName = '/archives';

  @override
  Widget build(BuildContext context) {
    final cars = context
        .watch<SettingsCarsController>()
        .cars
        .where((car) => car.isArchive)
        .toList();

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
        itemCount: cars.length,
        itemBuilder: (BuildContext context, int index) {
          return CarCard(car: cars[index]);
        },
      ),
    );
  }
}
