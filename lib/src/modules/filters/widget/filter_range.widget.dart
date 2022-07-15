import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterRange extends StatelessWidget {
  final String title;
  final Widget slider;
  final SfRangeValues values;

  const FilterRange({
    Key? key,
    required this.slider,
    required this.values,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const kValueWidth = 65.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Container(
              width: kValueWidth,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(values.start.toInt().toString(), textAlign: TextAlign.center),
            ),
            Expanded(child: slider),
            Container(
              width: kValueWidth,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(values.end.toInt().toString(), textAlign: TextAlign.center),
            ),
          ],
        ),
      ],
    );
  }
}
