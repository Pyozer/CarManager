import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../widgets/gallery_indicator.widget.dart';
import '../../widgets/return_button.widget.dart';

class CarGalleryViewArguments {
  final List<String> imagesUrl;
  final int defaultIndex;

  CarGalleryViewArguments({required this.imagesUrl, this.defaultIndex = 0});
}

class CarGalleryView extends StatefulWidget {
  final List<String> imagesUrl;
  final int defaultIndex;

  const CarGalleryView(
      {Key? key, required this.imagesUrl, this.defaultIndex = 0})
      : super(key: key);

  static const routeName = '/car_gallery';

  @override
  State<CarGalleryView> createState() => _CarGalleryViewState();
}

class _CarGalleryViewState extends State<CarGalleryView> {
  late final PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.defaultIndex);
    _currentPage = widget.defaultIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: _pageController,
            scrollPhysics: const BouncingScrollPhysics(),
            enableRotation: true,
            allowImplicitScrolling: true,
            onPageChanged: (int page) => setState(() => _currentPage = page),
            itemCount: widget.imagesUrl.length,
            builder: (_, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(
                  widget.imagesUrl[index],
                ),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(
                  tag: widget.imagesUrl[index],
                ),
              );
            },
            loadingBuilder: (_, ImageChunkEvent? progress) {
              return Center(
                child: CircularProgressIndicator(
                  value: progress?.expectedTotalBytes != null
                      ? progress!.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
          const ReturnButton(isClose: true),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: GalleryIndicators(
                currentPage: _currentPage + 1,
                totalPage: widget.imagesUrl.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
