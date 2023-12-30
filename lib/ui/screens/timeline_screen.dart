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
  final int mediaCount;
  final TimelineGroupBy zoomLevel;
  final bool isLastPage;
  final String? fetchMoreError;
  final ScrollController _scrollController = ScrollController();

  TimelineScreen(
      {super.key,
      required this.timelineActionListener,
      required this.mediaCount,
      required this.timelinePhotos,
      required this.zoomLevel,
      required this.isLastPage,
      this.fetchMoreError});

  @override
  Widget build(BuildContext context) {
    int selectedCount = _getSelectedCount();
    return Scaffold(
      appBar: timelinePhotos.isNotEmpty
          ? CupertinoNavigationBar(
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
            ) as PreferredSizeWidget
          : AppBar(
              title: Title(
                color: Theme.of(context).colorScheme.primary,
                child: const Center(
                  child: Text("No photo/video sync yet"),
                ),
              ),
            ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: NestedScrollView(
          headerSliverBuilder: (ctx, innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Center(
                  child: Text("$mediaCount medias"),
                ),
              ),
            ];
          },
          body: Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            interactive: true,
            thickness: 8,
            controller: _scrollController
              ..addListener(() {
                // nextPageTrigger will have a value equivalent to 80% of the list size.
                var nextPageTrigger =
                    0.8 * _scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current postion of the user on the screen has surpassed
                if (_scrollController.position.pixels > nextPageTrigger) {
                  // _loading = true;
                  debugPrint(
                      "timeline_screen::build::scrollListener > loading more ${!isLastPage}");
                  if (!isLastPage) {
                    timelineActionListener
                        .loadMore(timelinePhotos.values.last.last.date);
                  }
                }
              }),
            child: CustomScrollView(
              shrinkWrap: true,
              primary: false,
              controller: _scrollController,
              semanticChildCount: isLastPage ? mediaCount : mediaCount + 1,
              slivers: List<Widget>.generate(
                  timelinePhotos.length + (isLastPage ? 0 : 1), (index) {
                if (index == timelinePhotos.length) {
                  if (fetchMoreError != null) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Text("Error Loading media"),
                      ),
                    );
                  } else {
                    if (isLastPage) {
                      return const Spacer();
                    }
                    return const SliverToBoxAdapter(
                      child: LinearProgressIndicator(),
                    );
                  }
                }
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
