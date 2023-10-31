import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/bloc/base/data/base_data_bloc.dart';
import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/bloc/folder_selection/data/folder_selection_event.dart';
import 'package:tphotos/bloc/folder_selection/data/folder_selection_state.dart';
import 'package:tphotos/data/data_manager_impl.dart';

class FolderSelectionBloc extends BaseBloc {
  FolderSelectionBloc() : super(FolderSelectionStateInitial()) {
    on<FolderSelectionEventLoadSelection>(_loadSelection);
    on<FolderSelectionEventNewFolderSelected>(_newFolderSelected);
    on<FolderSelectionEventFolderUnSelected>(_folderUnSelected);
    on<FolderSelectionEventSaveSelection>(_saveSelection);
  }

  FutureOr<void> _loadSelection(
      FolderSelectionEventLoadSelection event, Emitter<BaseState> emitter) {
    List<String> savedFolders =
        DataManagerImpl.getInstance().preferencesSettingsApi.getSyncedFolders();
    emitter(FolderSelectionStateSelectionUpdated(savedFolders));
  }

  FutureOr<void> _newFolderSelected(
      FolderSelectionEventNewFolderSelected event, Emitter<BaseState> emitter) {
    emitter(FolderSelectionStateSelectionUpdated(
        <String>{...event.selectedFolders, event.newFolder}.toList()));
  }

  FutureOr<void> _folderUnSelected(
      FolderSelectionEventFolderUnSelected event, Emitter<BaseState> emitter) {
    List<String> selectedFolders = [...event.selectedFolders]
      ..removeAt(event.unselectedIndex);
    emitter(FolderSelectionStateSelectionUpdated(selectedFolders));
  }

  FutureOr<void> _saveSelection(
      FolderSelectionEventSaveSelection event, Emitter<BaseState> emitter) {
    DataManagerImpl.getInstance()
        .preferencesSettingsApi
        .updateSyncedFoldersList(event.selectedFolders);

    emitter(FolderSelectionStateSaved());
  }
}
