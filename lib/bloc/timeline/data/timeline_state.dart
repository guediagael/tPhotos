import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';
import 'package:tphotos/ui/models/timelie_group_by.dart';

class TimelineState extends BaseState {
  const TimelineState(List<Object?> properties) : super(properties);
}

class TimelineStateInitial extends TimelineState {
  const TimelineStateInitial() : super(const []);
}

class TimelineStateLoaded extends TimelineState {
  final Map<DateTime, List<PhotoListItem>> groupedPhotos;
  final TimelineGroupBy zoomLevel;

  TimelineStateLoaded({required this.groupedPhotos, required this.zoomLevel})
      : super([
          groupedPhotos.keys.toList(growable: false),
          groupedPhotos.entries.toList(growable: false)
        ]);
}
