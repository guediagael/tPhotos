
import 'package:tphotos/bloc/base/data/base_event.dart';

abstract class SettingsEvent extends BaseEvent {
  const SettingsEvent(super.properties);
}

class SettingsEventUpdateDeleteAfterSave extends SettingsEvent {
  final bool newSetting;

  SettingsEventUpdateDeleteAfterSave(this.newSetting) : super([newSetting]);
}

class SettingsEventUpdateAutoSync extends SettingsEvent {
  final bool newSetting;

  SettingsEventUpdateAutoSync(this.newSetting) : super([newSetting]);
}

class SettingsEventUpdatedSyncedFolders extends SettingsEvent{
  final List<String> folders;
  const SettingsEventUpdatedSyncedFolders(this.folders):super(folders);
}


class SettingsEventLogout extends SettingsEvent {
  const SettingsEventLogout() : super(const []);
}

class SettingsEventDeleteAccount extends SettingsEvent {
  const SettingsEventDeleteAccount() : super(const []);
}

class SettingsEventFreeUpSpace extends SettingsEvent {
  const SettingsEventFreeUpSpace() : super(const []);
}

class SettingsEventTriggerSync extends SettingsEvent {
  const SettingsEventTriggerSync():super(const []);

}