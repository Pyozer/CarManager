import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../widgets/gallery_indicator.widget.dart';
import '../../../widgets/image_network_loader.widget.dart';
import '../car_gallery.view.dart';

class CarGallery extends StatefulWidget {
  final List<String> imagesUrl;

  const CarGallery({Key? key, required this.imagesUrl}) : super(key: key);

  @override
  State<CarGallery> createState() => _CarGalleryState();
}

class _CarGalleryState extends State<CarGallery> {
  int _currentPage = 0;

  void _onImageTap(int index) {
    Navigator.of(context).pushNamed(
      CarGalleryView.routeName,
      arguments: CarGalleryViewArguments(
        imagesUrl: widget.imagesUrl,
        defaultIndex: index,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 275,
      child: Stack(
        children: [
          PageView(
            scrollDirection: Axis.horizontal,
            onPageChanged: (page) => setState(() => _currentPage = page),
            children: widget.imagesUrl.mapIndexed((index, imageUrl) {
              return Hero(
                tag: imageUrl,
                child: GestureDetector(
                  onTap: () => _onImageTap(index),
                  child: ImageNetworkLoader(imageUrl),
                ),
              );
            }).toList(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: GalleryIndicators(
                currentPage: _currentPage + 1,
                totalPage: widget.imagesUrl.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
