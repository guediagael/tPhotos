import 'package:tphotos/ui/models/photo_list_item.dart';
import 'package:tphotos/ui/models/timelie_group_by.dart';

abstract mixin class TimelineActionListener{
  void onRefresh();
  void onDeleteSelection();
  void onCancelSelection();
  void onPhotoPressed(PhotoListItem photoListItem);
  void onPhotoLongPress(PhotoListItem photoListItem, DateTime groupDate);
  void onDatePressed(DateTime dateListItem);
  void onSortByUpdated(TimelineGroupBy newSorting);
  void loadMore(DateTime dateTime);
}