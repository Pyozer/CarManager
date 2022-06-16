import 'package:flutter/material.dart';

class MapsCard extends StatelessWidget {
  final Widget child;

  const MapsCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 0),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: child,
        ),
      ),
    );
  }
}
