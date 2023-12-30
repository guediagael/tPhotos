import 'package:tphotos/bloc/base/navigator/base_nav_state.dart';

class FolderSelectionNavigationState extends BaseNavigatorState {
  const FolderSelectionNavigationState(super.properties);
}

class FolderSelectionNavigationStateInitial
    extends FolderSelectionNavigationState {
  FolderSelectionNavigationStateInitial() : super([]);
}

class FolderSelectionNavigationStateFoldersSaved
    extends FolderSelectionNavigationState {
  FolderSelectionNavigationStateFoldersSaved() : super([]);
}
