
import 'package:tphotos/bloc/base/navigator/base_nav_event.dart';

class SettingsNavigatorEvent extends BaseNavigatorEvent{
  const SettingsNavigatorEvent(super.props);
}

class SettingsNavigatorCloseEvent extends SettingsNavigatorEvent{
  SettingsNavigatorCloseEvent() : super([]);
}