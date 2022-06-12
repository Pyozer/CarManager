import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

import 'image_network_loader.widget.dart';

class AddImageSquare extends StatelessWidget {
  final String? imageUrl;
  final GestureTapCallback? onAdd;
  final GestureTapCallback? onImageTap;

  const AddImageSquare({
    Key? key,
    this.imageUrl,
    this.onAdd,
    this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReorderableWidget(
      key: Key(imageUrl ?? ''),
      reorderable: imageUrl != null,
      child: SizedBox.square(
        dimension: 100,
        child: Card(
          elevation: 5,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: imageUrl == null ? onAdd : onImageTap,
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ImageNetworkLoader(imageUrl!, height: 105),
                  )
                : const Center(child: Icon(Icons.add_a_photo, size: 105 / 2.7)),
          ),
        ),
      ),
    );
  }
}
