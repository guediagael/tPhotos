import 'package:flutter/material.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';
import 'package:tphotos/ui/widgets/photo_search.dart';

class PhotoDetailsScreen extends StatelessWidget {
  final PhotoListItem photoListItem;

  const PhotoDetailsScreen({super.key, required this.photoListItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Second Page'),
          ),
      body: Center(
        child: PhotoSearchWidget(
          photoListItem: photoListItem,
        ),
      ),
    );
  }
}
