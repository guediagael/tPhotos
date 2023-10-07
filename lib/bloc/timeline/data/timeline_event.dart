import 'package:tphotos/bloc/base/data/base_event.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';
import 'package:tphotos/ui/models/timelie_group_by.dart';

class TimelineEvent extends BaseEvent {
  const TimelineEvent(List<Object?> properties) : super(properties);
}

class TimelineEventLoad extends TimelineEvent {
  final DateTime initialDate;

  TimelineEventLoad(this.initialDate) : super([initialDate]);
}

class TimelineEventDeletePictures extends TimelineEvent {
  final Map<DateTime, List<PhotoListItem>> loadedList;

  TimelineEventDeletePictures(this.loadedList) : super([loadedList]);
}

class TimelineEventOnItemLongPress extends TimelineEvent {
  final PhotoListItem newSelection;
  final DateTime groupDate;
  final Map<DateTime, List<PhotoListItem>> loadedList;

  TimelineEventOnItemLongPress(
      {required this.loadedList,
      required this.newSelection,
      required this.groupDate})
      : super([newSelection, loadedList]);
}

class TimelineEventOnDateItemPress extends TimelineEvent {
  final DateTime newSelection;
  final Map<DateTime, List<PhotoListItem>> loadedList;

  TimelineEventOnDateItemPress(
      {required this.loadedList, required this.newSelection})
      : super([newSelection, loadedList]);
}

class TimelineEventOnCancelSelections extends TimelineEvent {
  final Map<DateTime, List<PhotoListItem>> loadedList;

  TimelineEventOnCancelSelections(this.loadedList) : super([loadedList]);
}

class TimelineEventOnSortUpdated extends TimelineEvent {
  final List<PhotoListItem> loadedList;
  final TimelineGroupBy zoomLevel;

  TimelineEventOnSortUpdated(
      {required this.loadedList, required this.zoomLevel})
      : super([loadedList, zoomLevel]);
}
