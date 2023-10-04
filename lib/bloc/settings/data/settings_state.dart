import 'package:tphotos/bloc/base/data/base_state.dart';

import 'settings.dart';

abstract class SettingsState extends BaseState {
  const SettingsState(List<Object?> properties) : super(properties);
}

class SettingStateInitial extends SettingsContainerState {
  SettingStateInitial(
      {required Settings settings,
      required String username,
      String? profilePicture})
      : super(
            settings: settings,
            username: username,
            profilePicture: profilePicture);
}

class SettingsContainerState extends SettingsState {
  final Settings settings;
  final String username;
  final String? profilePicture;

  SettingsContainerState(
      {required this.username, required this.settings, this.profilePicture})
      : super([settings, profilePicture, username]);
}

class SettingsStateSpaceCleared extends SettingsState {
  const SettingsStateSpaceCleared() : super(const []);
}
