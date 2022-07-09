import 'package:flutter/material.dart';

class FilterRange extends StatelessWidget {
  final String title;
  final RangeSlider slider;
  final RangeValues values;

  const FilterRange({
    Key? key,
    required this.slider,
    required this.values,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(values.start.toInt().toString()),
            ),
            Expanded(
              child: slider,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(values.end.toInt().toString()),
            ),
          ],
        ),
      ],
    );
  }
}
