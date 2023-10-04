import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/bloc/base/data/base_data_bloc.dart';
import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/data/local/preferences/preferences_id_api.dart';
import 'package:tphotos/data/local/preferences/preferences_settings_api.dart';

import 'settings.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends BaseBloc {
  final PreferencesSettingsApi preferencesSettingsApi;

  SettingsBloc(
      {required this.preferencesSettingsApi,
      required PreferencesIdApi preferencesIdApi})
      : super(SettingStateInitial(
            settings: Settings.fromSharedPreferences(preferencesSettingsApi),
            username: preferencesIdApi.getUsername() ?? 'Username',
            profilePicture: preferencesIdApi.getAvatarUrl())) {
    on<SettingsEventUpdateDeleteAfterSave>(_updateDeleteAfterSaveTrigger);
    on<SettingsEventUpdateAutoSync>(_updateAutoSyncTrigger);
    on<SettingsEventLogout>(_logout);
    on<SettingsEventDeleteAccount>(_deleteAccount);
    on<SettingsEventUpdatedSyncedFolders>(_updateSelectedFolders);
    on<SettingsEventFreeUpSpace>(_freeSpace);
    on<SettingsEventTriggerSync>(_startSync);
  }

  void _updateDeleteAfterSaveTrigger(
      SettingsEventUpdateDeleteAfterSave eventUpdateDeleteAfterSave,
      Emitter<BaseState> emitter) {
    final newValue = eventUpdateDeleteAfterSave.newSetting;
    final settings = Settings.fromSharedPreferences(preferencesSettingsApi)
        .copyWith(deleteAfterSave: newValue);
    preferencesSettingsApi.switchDeleteAfterSave(newValue);

    emitter(SettingsContainerState(
        settings: settings,
        username: (state as SettingsContainerState).username,
        profilePicture: (state as SettingsContainerState).profilePicture));
  }

  void _updateAutoSyncTrigger(SettingsEventUpdateAutoSync eventUpdateAutoSync,
      Emitter<BaseState> emitter) {
    final newValue = eventUpdateAutoSync.newSetting;
    final settings = Settings.fromSharedPreferences(preferencesSettingsApi)
        .copyWith(autoSync: newValue);
    preferencesSettingsApi.switchAutoSync(newValue);
    emitter(SettingsContainerState(
        settings: settings,
        username: (state as SettingsContainerState).username,
        profilePicture: (state as SettingsContainerState).profilePicture));
  }

  void _updateSelectedFolders(
      SettingsEventUpdatedSyncedFolders eventUpdatedSyncedFolders,
      Emitter<BaseState> emitter) {
    final newFolders = eventUpdatedSyncedFolders.folders;
    debugPrint("New folders : $newFolders");
    final settings = Settings.fromSharedPreferences(preferencesSettingsApi)
        .copyWith(selectedFolders: newFolders);
    preferencesSettingsApi.updateSyncedFoldersList(newFolders);
    emitter(SettingsContainerState(
        settings: settings,
        username: (state as SettingsContainerState).username,
        profilePicture: (state as SettingsContainerState).profilePicture));
  }

  void _logout(SettingsEventLogout eventLogout, Emitter<BaseState> emitter) {
    //TODO
  }

  void _deleteAccount(SettingsEventDeleteAccount eventDeleteAccount,
      Emitter<BaseState> emitter) {
    //TODO
  }

  void _freeSpace(
      SettingsEventFreeUpSpace eventFreeSpace, Emitter<BaseState> emitter) {
    emitter(const SettingsStateSpaceCleared());
  }

  void _startSync(
      SettingsEventTriggerSync eventTriggerSync, Emitter<BaseState> emitter) {
    emitter(SettingsContainerState(
        settings: (state as SettingsContainerState).settings,
        username: (state as SettingsContainerState).username,
        profilePicture: (state as SettingsContainerState).profilePicture));
  }
}
