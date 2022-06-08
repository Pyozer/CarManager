import 'package:flutter/material.dart';

class FiltersView extends StatefulWidget {
  const FiltersView({Key? key}) : super(key: key);

  static const routeName = '/filters';

  @override
  State<FiltersView> createState() => _FiltersViewState();
}

class _FiltersViewState extends State<FiltersView> {
  String _filterValue = 'Lotus';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Make'),
          DropdownButton<String>(
            value: _filterValue,
            onChanged: (value) => setState(() => _filterValue = value!),
            isExpanded: true,
            items: const [
              DropdownMenuItem(
                value: 'Lotus',
                child: Text('Lotus'),
              ),
              DropdownMenuItem(
                value: 'BMW',
                child: Text('BMW'),
              ),
              DropdownMenuItem(
                value: 'Volvo',
                child: Text('Volvo'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
