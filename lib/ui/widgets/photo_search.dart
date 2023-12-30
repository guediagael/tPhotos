import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';

class PhotoSearchWidget extends StatelessWidget {
  final PhotoListItem photoListItem;

  const PhotoSearchWidget({super.key, required this.photoListItem});

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: photoListItem.toString(),
        child: (photoListItem.localPath == null)
            ? CachedNetworkImage(
                imageUrl: photoListItem.uri!,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            Colors.red, BlendMode.colorBurn)),
                  ),
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : Image.file(File(photoListItem.localPath!)));
  }
}
