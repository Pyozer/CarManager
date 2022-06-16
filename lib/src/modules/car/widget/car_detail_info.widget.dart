import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CarDetailInfo extends StatelessWidget {
  final String title;
  final String content;
  final Widget? footer;

  const CarDetailInfo(
      {Key? key, required this.title, required this.content, this.footer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final borderRadius = BorderRadius.circular(12);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        onLongPress: () async {
          await Clipboard.setData(ClipboardData(text: content));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Copié !'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        borderRadius: borderRadius,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: Text(title, style: textTheme.bodySmall),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: Text(content, style: textTheme.titleSmall),
              ),
              if (footer != null) footer!,
            ],
          ),
        ),
      ),
    );
  }
}
