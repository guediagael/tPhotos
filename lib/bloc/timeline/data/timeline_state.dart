import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';

class TimelineState extends BaseState {
  const TimelineState(List<Object?> properties) : super(properties);
}

class TimelineStateInitial extends TimelineState {
  const TimelineStateInitial() : super(const []);
}

class TimelineStateLoaded extends TimelineState {
  final DateTime prevLastDate;
  final Map<DateTime, List<PhotoListItem>> groupedPhotos;

  TimelineStateLoaded({required this.prevLastDate, required this.groupedPhotos})
      : super([prevLastDate, groupedPhotos]);
}
