import 'package:flutter/material.dart';

class CarAddView extends StatefulWidget {
  const CarAddView({Key? key}) : super(key: key);

  static const routeName = '/car_add';

  @override
  State<CarAddView> createState() => _CarAddViewState();
}

class _CarAddViewState extends State<CarAddView> {
  String _filterValue = 'Lotus';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add car'),
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
