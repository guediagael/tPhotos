import 'package:tphotos/ui/models/photo_list_item.dart';

abstract mixin class TimelineActionListener{
  void onRefresh();
  void onDeleteSelection();
  void onCancelSelection();
  void onPhotoPressed(PhotoListItem photoListItem);
  void onPhotoLongPress(PhotoListItem photoListItem, DateTime groupDate);
  void onDatePressed(DateTime dateListItem);
  void onZoomOut();
  void onZoomIn();
}