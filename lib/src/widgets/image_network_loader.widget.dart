import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageNetworkLoader extends StatelessWidget {
  final String imageUrl;
  final double? height;

  const ImageNetworkLoader(this.imageUrl, {Key? key, this.height})
      : super(key: key);

  Widget _buildError() {
    return Container(
      height: height,
      color: const Color(0xFF282828),
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: height != null ? height! / 2.7 : 65,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildProgress(DownloadProgress progress) {
    return SizedBox(
      height: height,
      child: Center(
        child: CircularProgressIndicator(value: progress.progress),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      height: height,
      errorWidget: (_, __, ___) => _buildError(),
      fadeOutDuration: const Duration(milliseconds: 200),
      progressIndicatorBuilder: (_, __, progress) {
        return _buildProgress(progress);
      },
    );
  }
}
