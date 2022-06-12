import 'package:flutter/material.dart';

class CarSold extends StatelessWidget {
  const CarSold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Theme.of(context).colorScheme.error,
        child: const Text(
          'VENDU',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
