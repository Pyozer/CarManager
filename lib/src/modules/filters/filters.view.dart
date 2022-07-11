import 'dart:convert';

import 'package:flutter/material.dart';

import '../car/model/car.model.dart';
import 'models/filters.model.dart';
import 'widget/filter_range.widget.dart';

const kMaxHP = 500.0;
const kMinYear = 1950.0;
final kMaxYear = DateTime.now().year.toDouble();

class FiltersViewArguments {
  final Filters? baseFilters;

  FiltersViewArguments({this.baseFilters});
}

class FiltersView extends StatefulWidget {
  final Filters? baseFilters;

  const FiltersView({Key? key, required this.baseFilters}) : super(key: key);

  static const routeName = '/filters';

  @override
  State<FiltersView> createState() => _FiltersViewState();
}

class _FiltersViewState extends State<FiltersView> {
  RangeValues _hpRangeValues = const RangeValues(0, kMaxHP);
  RangeValues _yearRangeValues = RangeValues(kMinYear, kMaxYear);
  Filters _filters = Filters();

  @override
  void initState() {
    super.initState();
    if (widget.baseFilters != null) {
      _filters = Filters.fromJson(
        jsonDecode(jsonEncode(widget.baseFilters!.toJson())),
      );
    }
    _hpRangeValues = RangeValues(
      _filters.minHP?.toDouble() ?? 0,
      _filters.maxHP?.toDouble() ?? kMaxHP,
    );
    _yearRangeValues = RangeValues(
      _filters.minYear?.toDouble() ?? kMinYear,
      _filters.maxYear?.toDouble() ?? kMaxYear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          TextButton(
            onPressed: () => setState(() => _filters.reset()),
            child: const Text('RESET'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pop(_filters),
        icon: const Icon(Icons.search),
        label: const Text('Search'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<CarMake>(
            value: _filters.make,
            onChanged: (make) {
              setState(() => _filters.make = make);
            },
            isExpanded: true,
            decoration: const InputDecoration(
              label: Text('Make'),
              filled: true,
            ),
            items: CarMake.values
                .map((make) => DropdownMenuItem(
                      value: make,
                      child: Row(
                        children: [
                          Image.network(
                            make.logo,
                            height: 30.0,
                            width: 30.0,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12.0),
                          Text(make.name),
                        ],
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24.0),
          DropdownButtonFormField<String>(
            value: _filters.model,
            onChanged: (model) => setState(() => _filters.model = model!),
            isExpanded: true,
            decoration: const InputDecoration(
              label: Text('Model'),
              filled: true,
            ),
            items: kCars
                .where((car) => car.make == _filters.make)
                .map((car) => DropdownMenuItem(
                      value: car.model,
                      child: Text(car.model),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24.0),
          DropdownButtonFormField<HandDrive>(
            value: _filters.handDrive,
            onChanged: (handDrive) =>
                setState(() => _filters.handDrive = handDrive!),
            isExpanded: true,
            decoration: const InputDecoration(
              label: Text('Hand Drive'),
              filled: true,
            ),
            items: HandDrive.values
                .map((handDrive) => DropdownMenuItem(
                      value: handDrive,
                      child: Text(handDrive.name),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24.0),
          FilterRange(
            title: 'HP range',
            values: _hpRangeValues,
            slider: RangeSlider(
              values: _hpRangeValues,
              min: 0,
              max: kMaxHP,
              divisions: 50,
              labels: RangeLabels(
                _hpRangeValues.start.toInt().toString(),
                _hpRangeValues.end.toInt().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _hpRangeValues = values;
                  _filters.minHP = values.start.toInt();
                  _filters.maxHP = values.end.toInt();
                });
              },
            ),
          ),
          const SizedBox(height: 24.0),
          FilterRange(
            title: 'Year range',
            values: _yearRangeValues,
            slider: RangeSlider(
              values: _yearRangeValues,
              min: kMinYear,
              max: kMaxYear,
              divisions: (kMaxYear - kMinYear).toInt(),
              labels: RangeLabels(
                _yearRangeValues.start.toInt().toString(),
                _yearRangeValues.end.toInt().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _yearRangeValues = values;
                  _filters.minYear = values.start.toInt();
                  _filters.maxYear = values.end.toInt();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
