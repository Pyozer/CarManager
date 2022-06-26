import 'dart:convert';

import 'package:flutter/material.dart';

import 'models/filters.model.dart';


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
  Filters _filters = Filters();

  @override
  void initState() {
    super.initState();
    if (widget.baseFilters != null) {
      _filters = Filters.fromJson(
        jsonDecode(jsonEncode(widget.baseFilters!.toJson())),
      );
    }
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
            items: kCarMakes
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
          DropdownButtonFormField<Car>(
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
                      value: car,
                      child: Text(car.model),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
