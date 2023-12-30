import 'package:tphotos/bloc/base/data/base_event.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';
import 'package:tphotos/ui/models/timelie_group_by.dart';

class TimelineEvent extends BaseEvent {
  const TimelineEvent(super.properties);
}

class TimelineEventLoad extends TimelineEvent {
  final DateTime initialDate;

  TimelineEventLoad(this.initialDate) : super([initialDate]);
}

class TimelineEventLoadMore extends TimelineEvent {
  final DateTime initialDate;

  TimelineEventLoadMore(this.initialDate) : super([initialDate]);
}

class TimelineEventDeletePictures extends TimelineEvent {
  const TimelineEventDeletePictures() : super(const []);
}

class TimelineEventOnItemSelected extends TimelineEvent {
  final PhotoListItem newSelection;
  final DateTime groupDate;

  TimelineEventOnItemSelected(
      {required this.newSelection, required this.groupDate})
      : super([newSelection, groupDate]);
}

class TimelineEventOnDateItemSelected extends TimelineEvent {
  final DateTime newSelection;

  TimelineEventOnDateItemSelected({required this.newSelection})
      : super([newSelection]);
}

class TimelineEventOnCancelSelections extends TimelineEvent {
  const TimelineEventOnCancelSelections() : super(const []);
}

class TimelineEventOnSortUpdated extends TimelineEvent {
  final TimelineGroupBy zoomLevel;

  TimelineEventOnSortUpdated({required this.zoomLevel}) : super([zoomLevel]);
}

class TimelineEventLoadFolders extends TimelineEvent {
  TimelineEventLoadFolders() : super([]);
}

class TimelineEventFoldersUpdated extends TimelineEvent {
  final List<String> folders;

  TimelineEventFoldersUpdated(this.folders) : super([folders]);
}

