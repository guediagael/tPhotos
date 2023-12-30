import 'package:tphotos/bloc/base/navigator/base_nav_event.dart';

abstract class MainNavigatorEvent extends BaseNavigatorEvent {
  const MainNavigatorEvent(super.properties);
}

class MainNavigatorEventShowSearch extends MainNavigatorEvent {
  const MainNavigatorEventShowSearch(super.properties);
}

class MainNavigatorEventShowTimeLine extends MainNavigatorEvent {
  const MainNavigatorEventShowTimeLine(super.properties);
}

class MainNavigatorEventShowSettings extends MainNavigatorEvent {
  const MainNavigatorEventShowSettings() : super(const []);
}

