import 'package:flutter/material.dart';
import 'package:tphotos/ui/widgets/photo_search.dart';

import '../models/photo_list_item.dart';

class TimelineItem extends StatelessWidget {
  final PhotoListItem photoListItem;
  final Function onLongPressed;
  final Function onPressed;
  final bool isSelectionActivated;

  const TimelineItem(
      {Key? key,
      required this.photoListItem,
      required this.onLongPressed,
      required this.onPressed,
      this.isSelectionActivated = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onLongPress: () {
          debugPrint("timelineItem:: long pressed $photoListItem");
          onLongPressed();
        },
        onTap: () {
          debugPrint("timelineItem:: pressed $photoListItem");
          if (isSelectionActivated) {
            onLongPressed();
          } else {
            onPressed();
          }
        },
        child: !isSelectionActivated
            ? PhotoSearchWidget(photoListItem: photoListItem)
            : Stack(
                children: [
                  Center(
                      child: Padding(
                    padding:
                        EdgeInsets.all(photoListItem.isSelected ? 20.0 : 0),
                    child: PhotoSearchWidget(photoListItem: photoListItem),
                  )),
                  Positioned(
                      child: photoListItem.isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 24,
                            )
                          : const Icon(
                              Icons.circle_outlined,
                              size: 24,
                            ))
                ],
              ),
      ),
    );
  }

  Widget _getBody() {
    debugPrint('Selection activated $isSelectionActivated and '
        'is selected ${photoListItem.isSelected}');
    if (!isSelectionActivated) {
      return PhotoSearchWidget(photoListItem: photoListItem);
    }
    return Stack(
      children: [
        Center(
            child: Padding(
          padding: EdgeInsets.all(photoListItem.isSelected ? 20.0 : 0),
          child: PhotoSearchWidget(photoListItem: photoListItem),
        )),
        Positioned(
            child: photoListItem.isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 24,
                  )
                : const Icon(
                    Icons.circle_outlined,
                    size: 24,
                  ))
      ],
    );
  }
}
