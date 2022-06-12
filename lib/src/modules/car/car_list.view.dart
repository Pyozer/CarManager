import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'car_add.view.dart';
import 'widget/car_card.widget.dart';
import '../filters/filters.view.dart';
import '../settings/settings.controller.dart';
import '../settings/settings.view.dart';

/// Displays a list of SampleItems.
class CarListView extends StatelessWidget {
  const CarListView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  static const routeName = '/';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final carsSaved = controller.carsSaved;

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
            onPressed: () => Navigator.of(context).pushNamed(CarAddView.routeName),
            color: Theme.of(context).colorScheme.onSurface,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(SettingsView.routeName),
            color: Theme.of(context).colorScheme.onSurface,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed(FiltersView.routeName),
        icon: const Icon(Icons.filter_alt_outlined),
        label: const Text('Filters'),
        heroTag: 'Filters',
      ),
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        padding: const EdgeInsets.only(top: 16, bottom: 82),
        itemCount: carsSaved.length,
        itemBuilder: (BuildContext context, int index) {
          return CarCard(car: carsSaved[index]);
        },
      ),
    );
  }
}
