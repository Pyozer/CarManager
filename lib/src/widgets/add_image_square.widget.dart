import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

import '../models/image_data.model.dart';
import 'image_network_loader.widget.dart';

class AddImageSquare extends StatelessWidget {
  final ImageData? imageData;
  final double size;
  final GestureTapCallback? onAdd;
  final GestureTapCallback? onImageTap;

  const AddImageSquare({
    Key? key,
    this.imageData,
    required this.size,
    this.onAdd,
    this.onImageTap,
  }) : super(key: key);

  Widget _buildImage() {
    if (imageData is ImageFile) {
      return Image.file(
        (imageData as ImageFile).file,
        height: size,
        fit: BoxFit.cover,
      );
    }
    return ImageNetworkLoader((imageData as ImageURL).data, height: size);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableWidget(
      key: Key(imageData?.key ?? 'noReorderableKey'),
      reorderable: imageData != null,
      child: SizedBox.square(
        dimension: size,
        child: Card(
          elevation: 5.0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: imageData == null ? onAdd : onImageTap,
            child: imageData == null
                ? Center(child: Icon(Icons.add_a_photo, size: size / 2.7))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildImage(),
                  ),
          ),
        ),
      ),
    );
  }
}
