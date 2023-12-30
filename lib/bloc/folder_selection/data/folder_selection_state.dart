import 'package:tphotos/bloc/base/data/base_state.dart';

class FolderSelectionState extends BaseState {
  const FolderSelectionState(super.properties);
}

class FolderSelectionStateInitial extends FolderSelectionState {
  FolderSelectionStateInitial() : super([]);
}

class FolderSelectionStateSelectionUpdated extends FolderSelectionState {
  final List<String> selectedFolders;

  FolderSelectionStateSelectionUpdated(this.selectedFolders)
      : super([selectedFolders]);
}

class FolderSelectionStateSaved extends FolderSelectionState {
  FolderSelectionStateSaved() : super([]);
}
