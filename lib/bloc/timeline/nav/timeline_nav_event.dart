import 'package:tphotos/bloc/base/navigator/base_nav_event.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';

class TimelineNavigatorEvent extends BaseNavigatorEvent {
  const TimelineNavigatorEvent(List<Object?> props) : super(props);
}

class TimelineNavigatorEventShowImageDetails extends TimelineNavigatorEvent {
  final PhotoListItem photoListItem;

  TimelineNavigatorEventShowImageDetails(this.photoListItem)
      : super([photoListItem]);
}
