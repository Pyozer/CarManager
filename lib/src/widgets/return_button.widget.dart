import 'package:flutter/material.dart';

class ReturnButton extends StatelessWidget {
  final bool isClose;

  const ReturnButton({Key? key, this.isClose = false}) : super(key: key);

  static IconData _getBackIcon(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Icons.arrow_back_rounded;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Icons.arrow_back_ios_new_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 10,
          color: Colors.black45,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
          ),
          child: InkWell(
            onTap: Navigator.of(context).maybePop,
            borderRadius: BorderRadius.circular(35.0),
            child: SizedBox(
                width: 35,
                height: 35,
                child: isClose
                    ? const Icon(Icons.close)
                    : Icon(_getBackIcon(Theme.of(context).platform), size: 18)),
          ),
        ),
      ),
    );
  }
}
