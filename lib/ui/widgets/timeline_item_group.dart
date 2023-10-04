import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';

import 'timeline_item.dart';

class TimelineItemGroup extends StatelessWidget {
  final Function(PhotoListItem) onItemPressed;
  final Function(PhotoListItem, DateTime) onItemLongPress;
  final Function(DateTime dateTime) onDatePressed;
  final List<PhotoListItem> photos;
  final DateTime groupDate;
  final int zoomLevel;

  const TimelineItemGroup(
      {super.key,
      required this.onItemPressed,
      required this.onItemLongPress,
      required this.onDatePressed,
      required this.photos,
      required this.groupDate,
      required this.zoomLevel})
      : assert(zoomLevel > 0);

  @override
  Widget build(BuildContext context) {
    bool isSelectionActivated = photos.any((element) => element.isSelected);
    int itemsPerLine = 5;
    if (zoomLevel == 2) itemsPerLine = 4;
    if (zoomLevel == 3) itemsPerLine = 2;

    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 14, bottom: 8),
            child: ListTile(
              leading: Text(groupDate.toLocal().toString()),
              trailing: IconButton(
                icon: Icon((photos.every((element) => element.isSelected))
                    ? Icons.check_circle
                    : Icons.check_circle_outline),
                onPressed: () {
                  onDatePressed(groupDate);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverGrid.count(
                  crossAxisCount: itemsPerLine,
                  children: List<TimelineItem>.generate(photos.length, (index) {
                    final photo = photos[index];
                    if (kDebugMode) {
                      if (photo.isSelected) print("Selected $photo");
                    }
                    return TimelineItem(
                      photoListItem: photo,
                      isSelectionActivated: isSelectionActivated,
                      onPressed: () {
                        debugPrint(
                            "timeline_item_group::build photo pressed ${photos[index]}");
                        if (isSelectionActivated) {
                          onItemLongPress(photo,groupDate);
                        } else {
                          onItemPressed(photo);
                        }
                      },
                      onLongPressed: () {
                        debugPrint(
                            "timeline_item_group::build photo long pressed ${photos[index]}");
                        onItemLongPress(photo, groupDate);
                      },
                    );
                  }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
