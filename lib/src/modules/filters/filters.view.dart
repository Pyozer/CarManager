import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../car/model/car.model.dart';
import 'models/filters.model.dart';
import 'widget/filter_range.widget.dart';

const kMinHP = 0.0;
const kMaxHP = 500.0;
const kMinYear = 1990.0;
final kMaxYear = (DateTime.now().year + 1).toDouble();

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
  late SfRangeValues _hpRangeValues;
  late SfRangeValues _yearRangeValues;
  Filters _filters = Filters();

  @override
  void initState() {
    super.initState();
    if (widget.baseFilters != null) {
      _filters = Filters.fromJson(
        jsonDecode(jsonEncode(widget.baseFilters!.toJson())),
      );
    }
    _initSliders();
  }

  void _initSliders() {
    _hpRangeValues = SfRangeValues(
      _filters.minHP?.toDouble() ?? kMinHP,
      _filters.maxHP?.toDouble() ?? kMaxHP,
    );
    _yearRangeValues = SfRangeValues(
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
            onPressed: () => setState(() {
              _filters.reset();
              _initSliders();
            }),
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
        padding: const EdgeInsets.all(16.0),
        // TODO: Add a scrollable list with slider working
        physics: const NeverScrollableScrollPhysics(),
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
            slider: SfRangeSliderTheme(
              data: SfRangeSliderThemeData(thumbRadius: 14.0),
              child: SfRangeSlider(
                min: kMinHP,
                max: kMaxHP,
                values: _hpRangeValues,
                dragMode: SliderDragMode.both,
                enableTooltip: true,
                interval: 5.0,
                stepSize: 5.0,
                startThumbIcon: const Icon(
                  Icons.arrow_back_ios_outlined,
                  size: 12.0,
                  color: Colors.black,
                ),
                endThumbIcon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 12.0,
                  color: Colors.black,
                ),
                onChanged: (SfRangeValues newValues) {
                  setState(() {
                    _hpRangeValues = newValues;
                    _filters.minHP = newValues.start.toInt();
                    _filters.maxHP = newValues.end.toInt();
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          FilterRange(
            title: 'Year range',
            values: _yearRangeValues,
            slider: SfRangeSliderTheme(
              data: SfRangeSliderThemeData(thumbRadius: 14.0),
              child: SfRangeSlider(
                min: kMinYear,
                max: kMaxYear,
                values: _yearRangeValues,
                dragMode: SliderDragMode.both,
                enableTooltip: true,
                interval: 1.0,
                stepSize: 1.0,
                startThumbIcon: const Icon(
                  Icons.arrow_back_ios_outlined,
                  size: 12.0,
                  color: Colors.black,
                ),
                endThumbIcon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 12.0,
                  color: Colors.black,
                ),
                onChanged: (SfRangeValues newValues) {
                  setState(() {
                    _yearRangeValues = newValues;
                    _filters.minYear = newValues.start.toInt();
                    _filters.maxYear = newValues.end.toInt();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
