import 'package:tphotos/bloc/base/data/base_event.dart';

class FolderSelectionEvent extends BaseEvent {
  const FolderSelectionEvent(List<Object?> properties) : super(properties);
}

class FolderSelectionEventNewFolderSelected extends FolderSelectionEvent {
  final List<String> selectedFolders;
  final String newFolder;

  FolderSelectionEventNewFolderSelected(
      {required this.selectedFolders, required this.newFolder})
      : super([selectedFolders, newFolder]);
}

class FolderSelectionEventFolderUnSelected extends FolderSelectionEvent {
  final List<String> selectedFolders;
  final int unselectedIndex;

  FolderSelectionEventFolderUnSelected(
      {required this.selectedFolders, required this.unselectedIndex})
      : super([selectedFolders, unselectedIndex]);
}

class FolderSelectionEventSaveSelection extends FolderSelectionEvent {
  final List<String> selectedFolders;

  FolderSelectionEventSaveSelection(this.selectedFolders)
      : super([selectedFolders]);
}

class FolderSelectionEventLoadSelection extends FolderSelectionEvent {
  FolderSelectionEventLoadSelection() : super([]);
}
