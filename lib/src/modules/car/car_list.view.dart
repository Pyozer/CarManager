import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../utils/extensions/media_query_data.extension.dart';
import '../settings/settings.view.dart';
import '../settings/settings_cars.controller.dart';
import 'car_add.view.dart';
import 'state/car_list_base.state.dart';
import 'widget/car_card.widget.dart';

class CarListViewArguments {
  final bool? isSold;

  CarListViewArguments({this.isSold});
}

class CarListView extends StatefulWidget {
  final bool isSold;

  const CarListView({Key? key, this.isSold = false}) : super(key: key);

  static const routeName = '/';

  @override
  State<CarListView> createState() => _CarListViewState();
}

class _CarListViewState extends CarListBaseState<CarListView> {
  Future<void> _onRefresh() {
    return context.read<SettingsCarsController>().load();
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    final cars = context
        .watch<SettingsCarsController>()
        .cars
        .where((car) => car.isSold == widget.isSold)
        .where(isMatchingFilter)
        .toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: !widget.isSold
            ? Text(
                translate.carListTitle,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              )
            : Text(translate.carSoldTitle),
        actions: (!widget.isSold)
            ? [
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
                    Navigator.of(context).pushNamed(
                      CarListView.routeName,
                      arguments: CarListViewArguments(isSold: true),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  color: Theme.of(context).colorScheme.onSurface,
                  onPressed: () {
                    Navigator.of(context).pushNamed(SettingsView.routeName);
                  },
                ),
              ]
            : null,
      ),
      floatingActionButton: buildFilterBtn(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: cars.isEmpty
            ? buildNoResult()
            : ListView.builder(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).paddingAboveFAB,
                ),
                itemCount: cars.length + 1,
                itemBuilder: (_, int index) {
                  if (index == 0) {
                    return buildFilters();
                  }
                  return CarCard(car: cars[index - 1]);
                }),
      ),
    );
  }
}
