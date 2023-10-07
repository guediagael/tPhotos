import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tphotos/action_listeners/timeline_action_listener.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';
import 'package:tphotos/ui/models/timelie_group_by.dart';
import 'package:tphotos/ui/widgets/buttons/timeline_selection_floating_button.dart';
import 'package:tphotos/ui/widgets/timeline_item_group.dart';

class TimelineScreen extends StatelessWidget {
  final TimelineActionListener timelineActionListener;
  final Map<DateTime, List<PhotoListItem>> timelinePhotos;
  final TimelineGroupBy zoomLevel;

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
      body: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: NestedScrollView(
          headerSliverBuilder: (ctx, innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child:timelinePhotos.isNotEmpty ? CupertinoNavigationBar(
                  middle: CupertinoSegmentedControl<TimelineGroupBy>(
                    children: const <TimelineGroupBy, Widget>{
                      TimelineGroupBy.year: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Year'),
                      ),
                      TimelineGroupBy.month: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Month'),
                      ),
                      TimelineGroupBy.day: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Day'),
                      ),
                    },
                    onValueChanged: (TimelineGroupBy newGroupBy) {
                      timelineActionListener.onSortByUpdated(newGroupBy);
                    },
                    groupValue: zoomLevel,
                  ),
                ): const Center(child: Text("No photo/video sync yet"),),
              ),
            ];
          },
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
        ),
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
}
