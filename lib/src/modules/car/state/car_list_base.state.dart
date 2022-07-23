import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../filters/filters.view.dart';
import '../../filters/models/filters.model.dart';
import '../model/car.model.dart';

abstract class CarListBaseState<T extends StatefulWidget> extends State<T> {
  Filters filters = Filters();

  bool isMatchingFilter(Car car) {
    if (filters.make != null && filters.make!.name != car.make.name) {
      return false;
    }
    if (filters.model != null && filters.model! != car.model) {
      return false;
    }
    if (filters.minYear != null && filters.minYear! > car.year) {
      return false;
    }
    if (filters.maxYear != null && filters.maxYear! < car.year) {
      return false;
    }
    if (filters.minHP != null && filters.minHP! > car.hp) {
      return false;
    }
    if (filters.maxHP != null && filters.maxHP! < car.hp) {
      return false;
    }
    if (filters.handDrive != null && filters.handDrive! != car.handDrive) {
      return false;
    }
    return true;
  }

  Widget buildFilters() {
    final translate = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        spacing: 12.0,
        children: [
          if (filters.make != null)
            Chip(
              label: Text(filters.make!.name),
              onDeleted: () {
                setState(() => filters.make = null);
              },
            ),
          if (filters.model != null)
            Chip(
              label: Text(filters.model!),
              onDeleted: () {
                setState(() => filters.model = null);
              },
            ),
          if (filters.handDrive != null)
            Chip(
              label: Text(filters.handDrive!.name),
              onDeleted: () {
                setState(() => filters.handDrive = null);
              },
            ),
          if (filters.minHP != null && filters.minHP != kMinHP)
            Chip(
              label: Text('HP ≥ ${filters.minHP}'),
              onDeleted: () {
                setState(() => filters.minHP = null);
              },
            ),
          if (filters.maxHP != null && filters.maxHP != kMaxHP)
            Chip(
              label: Text('HP ≤ ${filters.maxHP}'),
              onDeleted: () {
                setState(() => filters.maxHP = null);
              },
            ),
          if (filters.minYear != null && filters.minYear != kMinYear)
            Chip(
              label: Text('${translate.year} ≥ ${filters.minYear}'),
              onDeleted: () {
                setState(() => filters.minYear = null);
              },
            ),
          if (filters.maxYear != null && filters.maxYear != kMaxYear)
            Chip(
              label: Text('${translate.year} ≤ ${filters.maxYear}'),
              onDeleted: () {
                setState(() => filters.maxYear = null);
              },
            ),
        ],
      ),
    );
  }

  Widget buildFilterBtn() {
    final translate = AppLocalizations.of(context)!;

    return FloatingActionButton.extended(
      onPressed: () async {
        final newFilters = await Navigator.of(context).pushNamed<Filters>(
          FiltersView.routeName,
          arguments: FiltersViewArguments(baseFilters: filters),
        );
        if (newFilters == null || !mounted) return;

        setState(() => filters = newFilters);
      },
      heroTag: 'filters',
      icon: const Icon(Icons.filter_alt_outlined),
      label: Text(translate.filters),
    );
  }

  Widget buildNoResult() {
    final translate = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildFilters(),
        Expanded(
          child: Center(
            child: Text(
              translate.noCarsFound,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
      ],
    );
  }
}
