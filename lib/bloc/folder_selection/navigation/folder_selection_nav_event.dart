import 'package:tphotos/bloc/base/navigator/base_nav_event.dart';

class FolderSelectionNavigationEvent extends BaseNavigatorEvent {
  const FolderSelectionNavigationEvent(List<Object?> properties)
      : super(properties);
}

class FolderSelectionNavigationEventSelectionSaved
    extends FolderSelectionNavigationEvent {
  FolderSelectionNavigationEventSelectionSaved() : super([]);
}
