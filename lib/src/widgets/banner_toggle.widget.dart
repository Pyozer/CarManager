import 'package:flutter/material.dart';

class BannerToggle extends StatelessWidget {
  final Widget child;
  final bool display;
  final String message;
  final BannerLocation location;
  final Color color;

  const BannerToggle({
    Key? key,
    required this.child,
    this.display = true,
    required this.message,
    required this.location,
    this.color = const Color(0xA0B71C1C),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!display) return child;

    return Banner(
      location: location,
      message: message,
      color: color,
      child: child,
    );
  }
}
