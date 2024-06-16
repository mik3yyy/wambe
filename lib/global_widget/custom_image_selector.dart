import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wambe/global_widget/image_render_widget.dart';
import 'package:wambe/models/media.dart';

class SelectableImageWidget extends StatelessWidget {
  final Media image;
  final bool isSelected;
  final bool isVisible;
  final Function(int) onSelect;

  SelectableImageWidget(
      {required this.image,
      required this.isSelected,
      required this.onSelect,
      required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ImageRenderWidget.network(
              imageUrl: image.url,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // if (isSelected)
        if (isVisible)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => onSelect(image.id),
              icon: Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.check_circle_outline_outlined,
                  color: Colors.white),
            ),
          ),
      ],
    );
  }
}
