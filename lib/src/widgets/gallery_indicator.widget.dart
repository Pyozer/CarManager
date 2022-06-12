import 'package:flutter/material.dart';

class GalleryIndicators extends StatelessWidget {
  final int currentPage;
  final int totalPage;

  const GalleryIndicators(
      {Key? key, required this.currentPage, required this.totalPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: Colors.black45, brightness: Brightness.dark),
      child: Chip(
        avatar: const Icon(Icons.image_outlined, size: 18),
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.fromLTRB(6, 4, 4, 4),
        label: Text('$currentPage / $totalPage'),
      ),
    );
  }
}
