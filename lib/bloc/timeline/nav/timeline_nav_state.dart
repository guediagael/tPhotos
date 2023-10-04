import 'package:tphotos/bloc/base/navigator/base_nav_state.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';

class TimelineNavigatorStateInitial extends BaseNavigatorState {
  const TimelineNavigatorStateInitial() : super(const []);
}

class TimelineNavigatorStateShowFullPicture extends BaseNavigatorState {
  final PhotoListItem item;

  TimelineNavigatorStateShowFullPicture(this.item) : super([item]);
}
