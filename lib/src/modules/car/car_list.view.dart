import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../settings/settings_cars.controller.dart';
import 'car_add.view.dart';
import 'car_archive_list.view.dart';
import 'widget/car_card.widget.dart';
import '../filters/filters.view.dart';
import '../settings/settings.view.dart';

class CarListView extends StatefulWidget {
  const CarListView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<CarListView> createState() => _CarListViewState();
}

class _CarListViewState extends State<CarListView> {
  Future<void> _onRefresh() {
    return context.read<SettingsCarsController>().load();
  }

  @override
  Widget build(BuildContext context) {
    final cars = context
        .watch<SettingsCarsController>()
        .cars
        .where((car) => !car.isArchive)
        .toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          AppLocalizations.of(context)!.carListTitle,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: () {
              Navigator.of(context).pushNamed(CarAddView.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.archive_outlined),
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: () {
              Navigator.of(context).pushNamed(CarArchiveListView.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsView.routeName);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed(FiltersView.routeName),
        icon: const Icon(Icons.filter_alt_outlined),
        label: const Text('Filters'),
        heroTag: 'Filters',
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 16, bottom: 82),
          itemCount: cars.length,
          itemBuilder: (_, int index) => CarCard(car: cars[index]),
        ),
      ),
    );
  }
}
