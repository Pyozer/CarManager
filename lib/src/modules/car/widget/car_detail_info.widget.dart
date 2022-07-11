import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CarDetailInfo extends StatelessWidget {
  final String title;
  final Widget child;
  final String? copyableText;

  const CarDetailInfo(
      {Key? key, required this.title, required this.child, this.copyableText})
      : super(key: key);

  Future<void> _copyText(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copié !'),
        duration: Duration(seconds: 1),
      ),
    );
    await Clipboard.setData(ClipboardData(text: copyableText));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          trailing: copyableText != null
              ? IconButton(
                  icon: const Icon(Icons.copy, size: 15.0),
                  onPressed: () => _copyText(context),
                )
              : null,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
          child: child,
        ),
      ],
    );
  }
}
