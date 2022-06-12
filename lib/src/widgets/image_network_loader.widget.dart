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

  Widget _buildProgress(ImageChunkEvent progress) {
    return SizedBox(
      height: height,
      child: Center(
        child: CircularProgressIndicator(
          value: progress.expectedTotalBytes != null
              ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      height: height,
      errorBuilder: (_, __, ___) => _buildError(),
      loadingBuilder: (_, image, progress) {
        if (progress == null) return image;
        return _buildProgress(progress);
      },
    );
  }
}
