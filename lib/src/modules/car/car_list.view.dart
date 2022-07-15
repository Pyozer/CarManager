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
import 'model/car.model.dart';
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

  bool _isMatchingFilter(Car car) {
    if (_filters.make != null && _filters.make!.name != car.make.name) {
      return false;
    }
    if (_filters.model != null && _filters.model! != car.model) {
      return false;
    }
    if (_filters.minYear != null && _filters.minYear! > car.year) {
      return false;
    }
    if (_filters.maxYear != null && _filters.maxYear! < car.year) {
      return false;
    }
    if (_filters.minHP != null && _filters.minHP! > car.hp) {
      return false;
    }
    if (_filters.maxHP != null && _filters.maxHP! < car.hp) {
      return false;
    }
    if (_filters.handDrive != null && _filters.handDrive! != car.handDrive) {
      return false;
    }
    return true;
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
              label: Text(_filters.model!),
              onDeleted: () {
                setState(() => _filters.model = null);
              },
            ),
          if (_filters.handDrive != null)
            Chip(
              label: Text(_filters.handDrive!.name),
              onDeleted: () {
                setState(() => _filters.handDrive = null);
              },
            ),
          if (_filters.minHP != null && _filters.minHP != kMinHP)
            Chip(
              label: Text('HP ≥ ${_filters.minHP}'),
              onDeleted: () {
                setState(() => _filters.minHP = null);
              },
            ),
          if (_filters.maxHP != null && _filters.maxHP != kMaxHP)
            Chip(
              label: Text('HP ≤ ${_filters.maxHP}'),
              onDeleted: () {
                setState(() => _filters.maxHP = null);
              },
            ),
          if (_filters.minYear != null && _filters.minYear != kMinYear)
            Chip(
              label: Text('Year ≥ ${_filters.minYear}'),
              onDeleted: () {
                setState(() => _filters.minYear = null);
              },
            ),
          if (_filters.maxYear != null && _filters.maxYear != kMaxYear)
            Chip(
              label: Text('Year ≤ ${_filters.maxYear}'),
              onDeleted: () {
                setState(() => _filters.maxYear = null);
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
        .where(_isMatchingFilter)
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
          final filters = await Navigator.of(context).pushNamed<Filters>(
            FiltersView.routeName,
            arguments: FiltersViewArguments(baseFilters: _filters),
          );
          if (filters == null || !mounted) return;

          setState(() => _filters = filters);
        },
        icon: const Icon(Icons.filter_alt_outlined),
        label: const Text('Filters'),
        heroTag: 'Filters',
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: cars.isEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildFilters(),
                  Expanded(
                    child: Center(
                      child: Text(
                        'No cars found 😱',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                ],
              )
            : ListView.builder(
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
