import 'package:flutter/material.dart';
import 'package:tphotos/action_listeners/timeline_action_listener.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';
import 'package:tphotos/ui/widgets/buttons/timeline_selection_floating_button.dart';
import 'package:tphotos/ui/widgets/timeline_item_group.dart';

class TimelineScreen extends StatelessWidget {
  final TimelineActionListener timelineActionListener;
  final Map<DateTime, List<PhotoListItem>> timelinePhotos;
  final int zoomLevel;

  const TimelineScreen(
      {Key? key,
      required this.timelineActionListener,
      required this.timelinePhotos,
      required this.zoomLevel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedCount = _getSelectedCount();
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        primary: false,
        slivers: List<Widget>.generate(timelinePhotos.length, (index) {
          DateTime date = timelinePhotos.keys.elementAt(index);
          return TimelineItemGroup(
              onItemPressed: timelineActionListener.onPhotoPressed,
              onItemLongPress: timelineActionListener.onPhotoLongPress,
              onDatePressed: timelineActionListener.onDatePressed,
              photos: timelinePhotos[date]!,
              zoomLevel: zoomLevel,
              groupDate: date);
        }),
      ),
      floatingActionButton: selectedCount > 0
          ? SelectedPhotosMenu(
              count: selectedCount,
              onCancel: () {
                timelineActionListener.onCancelSelection();
              },
              onDeleteSelection: () {
                timelineActionListener.onDeleteSelection();
              },
            )
          : null,
    );
  }

  int _getSelectedCount() {
    int count = 0;
    timelinePhotos.forEach((key, value) {
      count += value.where((element) => element.isSelected).length;
    });
    return count;
  }

// List<Widget> _getSlivers() {
//   var slivers = <Widget>[];
//   for (var date in groupedItems.keys) {
//     final photos = groupedItems[date]!;
//     slivers.add(SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 4),
//         child: Container(
//           padding: const EdgeInsets.all(4),
//           child: Text(date),
//         ),
//       ),
//     ));
//     slivers.add(SliverPadding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       sliver: SliverGrid.count(
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//         crossAxisCount: 3,
//         children: List<TimelineItem>.generate(photos.length, (index) {
//           final photo = photos[index];
//           if (kDebugMode) {
//             if (photo.isSelected) print("Selected $photo");
//           }
//           return TimelineItem(
//               photoListItem: photo,
//               isSelectionActivated:
//               onPressed: ()
//           {
//             debugPrint("photo pressed ${photos[index]}");
//           },
//           onLongPressed: () {
//           debugPrint("photo long pressed ${photos[index]}");
//           _bloc.add(TimelineEventOnItemLongPress(
//           selectedPhotos: selectedItems,
//           loadedList: groupedItems,
//           newSelection: photos[index]));
//           },
//           );
//         }),
//       ),
//     ));
//   }
//   return slivers;
// }
}
