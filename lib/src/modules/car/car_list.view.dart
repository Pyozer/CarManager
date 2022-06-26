import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../utils/extensions/media_query_data.extension.dart';
import '../filters/filters.view.dart';
import '../filters/models/filters.model.dart';
import '../settings/settings.view.dart';
import '../settings/settings_cars.controller.dart';
import 'car_add.view.dart';
import 'car_archive_list.view.dart';
import 'widget/car_card.widget.dart';

class CarListView extends StatefulWidget {
  const CarListView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<CarListView> createState() => _CarListViewState();
}

class _CarListViewState extends State<CarListView> {
  Filters _filters = Filters();

  Future<void> _onRefresh() {
    return context.read<SettingsCarsController>().load();
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        spacing: 12.0,
        children: [
          if (_filters.make != null)
            Chip(
              label: Text(_filters.make!.name),
              onDeleted: () {
                setState(() => _filters.make = null);
              },
            ),
          if (_filters.model != null)
            Chip(
              label: Text(_filters.model!.model),
              onDeleted: () {
                setState(() => _filters.model = null);
              },
            ),
        ],
      ),
    );
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
        onPressed: () async {
          final filters = await Navigator.of(context).pushNamed<Filters>(FiltersView.routeName);
          if (filters == null || !mounted) return;

          setState(() => _filters = filters);
        },
        icon: const Icon(Icons.filter_alt_outlined),
        label: const Text('Filters'),
        heroTag: 'Filters',
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).paddingAboveFAB,
            ),
            itemCount: cars.length + 1,
            itemBuilder: (_, int index) {
              if (index == 0) {
                return _buildFilters();
              }
              return CarCard(car: cars[index - 1]);
            }),
      ),
    );
  }
}
