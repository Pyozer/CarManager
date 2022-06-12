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
  static const routeName = '/car_gallery';

  const CarGalleryView({Key? key}) : super(key: key);

  @override
  State<CarGalleryView> createState() => _CarGalleryViewState();
}

class _CarGalleryViewState extends State<CarGalleryView> {
  PageController? _pageController;
  int? _currentPage;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments! as CarGalleryViewArguments;
    _pageController ??= PageController(initialPage: args.defaultIndex);
    _currentPage ??= args.defaultIndex;

    return Scaffold(
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: _pageController,
            scrollPhysics: const BouncingScrollPhysics(),
            enableRotation: true,
            onPageChanged: (int page) => setState(() => _currentPage = page),
            itemCount: args.imagesUrl.length,
            builder: (_, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(args.imagesUrl[index]),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(
                  tag: args.imagesUrl[index],
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
                currentPage: _currentPage! + 1,
                totalPage: args.imagesUrl.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
