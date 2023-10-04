
import 'package:tphotos/bloc/base/navigator/base_nav_event.dart';

abstract class MainNavigatorEvent extends BaseNavigatorEvent {
  const MainNavigatorEvent(List<Object?> properties) : super(properties);
}

class MainNavigatorEventShowSearch extends MainNavigatorEvent {
  const MainNavigatorEventShowSearch(List<Object?> properties)
      : super(properties);
}

class MainNavigatorEventShowTimeLine extends MainNavigatorEvent {
  const MainNavigatorEventShowTimeLine(List<Object?> properties)
      : super(properties);
}

class MainNavigatorEventShowSettings extends MainNavigatorEvent {
  const MainNavigatorEventShowSettings() : super(const []);
}

class MainNavigatorEventAddNew extends MainNavigatorEvent {
  const MainNavigatorEventAddNew() : super(const []);
}

class MainNavigatorEventOpenGallery extends MainNavigatorEvent {
  MainNavigatorEventOpenGallery() : super([]);
}

class MainNavigatorAddVideoFromGallery extends MainNavigatorEvent {
  MainNavigatorAddVideoFromGallery() : super([]);
}

class MainNavigatorEventOpenCamera extends MainNavigatorEvent {
  MainNavigatorEventOpenCamera() : super([]);
}
