import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
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

  bool _checkParent(String path, List<String> folders) {
    debugPrint("folder_selection_bloc::_checkParent of $path in $folders ");
    Directory dir = Directory(path);
    if (folders.isEmpty) {
      return false;
    }
    if (folders.contains(dir.parent.path)) {
      return true;
    }
    if (dir.parent.existsSync() && path.allMatches('/').length > 1) {
      debugPrint("folder_selection_bloc::_checkParent ${dir.parent.path}");
      return _checkParent(dir.parent.path, folders);
    } else {
      return false;
    }
  }

  List<String> _checkChildren(String path, List<String> folders) {
    debugPrint("folder_selection_bloc::_checkChildren $path in $folders");
    List<String> existingFiles = [];

    Directory dir = Directory(path);
    for (FileSystemEntity fileSystemEntity in dir.listSync(recursive: true)) {
      debugPrint(
          "folder_selection_bloc::_checkChildren checking ${fileSystemEntity.path}");
      if (folders.contains(fileSystemEntity.path)) {
        existingFiles.add(fileSystemEntity.path);
      }
    }
    return existingFiles;
  }

  FutureOr<void> _newFolderSelected(
      FolderSelectionEventNewFolderSelected event, Emitter<BaseState> emitter) {
    debugPrint("folder_selection_bloc::_newFolderSelected ${event.newFolder}");
    late List<String> newSelections = event.selectedFolders;
    if (!_checkParent(event.newFolder, event.selectedFolders)) {
      newSelections = [...event.selectedFolders, event.newFolder];
    }
    emitter(FolderSelectionStateSelectionUpdated([
      ...newSelections.where((element) =>
          !_checkChildren(event.newFolder, newSelections).contains(element))
    ]));
  }

  FutureOr<void> _folderUnSelected(
      FolderSelectionEventFolderUnSelected event, Emitter<BaseState> emitter) {
    List<String> selectedFolders = [...event.selectedFolders]
      ..removeAt(event.unselectedIndex);
    emitter(FolderSelectionStateSelectionUpdated(selectedFolders));
  }

  FutureOr<void> _saveSelection(
      FolderSelectionEventSaveSelection event, Emitter<BaseState> emitter) {
    Set<Directory> dirs =
        [...event.selectedFolders].map((e) => Directory(e)).toSet();
    List<String> finalFolders = dirs
        .where((dir) => !dirs.contains(dir.parent))
        .map((e) => e.path)
        .toList();
    DataManagerImpl.getInstance()
        .preferencesSettingsApi
        .updateSyncedFoldersList(finalFolders);
    emitter(FolderSelectionStateSaved());
  }
}
