import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/bloc/base/data/base_data_bloc.dart';
import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/bloc/main/data/main_event.dart';
import 'package:tphotos/bloc/main/data/main_state.dart';
import 'package:tphotos/data/data_manager_impl.dart';

class MainBloc extends BaseBloc {
  MainBloc() : super(MainStateInitial()) {
    on<MainEventCheckFirstLaunchFlag>(_onCheckFirstLaunchFlags);
    on<MainEventPermissionRequested>(_onPermissionRequested);
    on<MainEventCheckUpdatedRootPaths>(_onRootPathCheck);
  }

  void _onCheckFirstLaunchFlags(
      MainEventCheckFirstLaunchFlag event, Emitter<BaseState> emitter) {
    bool isFirstLaunch = DataManagerImpl.getInstance()
        .preferencesSettingsApi
        .checkIsFirstLaunch();
    emitter(MainStateFirstLaunchFlagLoaded(isFirstLaunch));
    DataManagerImpl.getInstance()
        .preferencesSettingsApi
        .updateFirstLaunchFlag(false);
  }

  void _onPermissionRequested(
      MainEventPermissionRequested event, Emitter<BaseState> emitter) {
    List<String> syncedFolders =
        DataManagerImpl.getInstance().preferencesSettingsApi.getSyncedFolders();
    var checkSum =
        base64Encode(sha1.convert(utf8.encode(syncedFolders.join(","))).bytes);
    emitter(MainStateFolderCountLoaded(
        count: syncedFolders.length, filesChecksum: checkSum));
  }

  void _onRootPathCheck(
      MainEventCheckUpdatedRootPaths event, Emitter<BaseState> emitter) {
    bool foldersUpdated = DataManagerImpl.getInstance()
        .preferencesSettingsApi
        .checkFoldersUpdatedFlag();
    if (foldersUpdated) {
      List<String> syncedFolders =
      DataManagerImpl.getInstance().preferencesSettingsApi.getSyncedFolders();
      int count = syncedFolders.length;
      var checkSum =
      base64Encode(sha1.convert(utf8.encode(syncedFolders.join(","))).bytes);
      emitter(MainStateFolderCountLoaded(count:count, filesChecksum: checkSum));
    }
    DataManagerImpl.getInstance()
        .preferencesSettingsApi
        .updateFoldersUpdatesFlag(false);
  }
}
