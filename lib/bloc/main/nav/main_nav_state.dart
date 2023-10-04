
import 'package:tphotos/bloc/base/navigator/base_nav_state.dart';

abstract class MainNavigatorState extends BaseNavigatorState {
  const MainNavigatorState(List<Object?> props) : super(props);
}

class MainNavigatorStateShowSettings extends MainNavigatorState {
  MainNavigatorStateShowSettings() : super([]);
}

class MainNavigatorStateOpenGallery extends MainNavigatorState {
  final List<String> preselectedElements;

  const MainNavigatorStateOpenGallery(this.preselectedElements)
      : super(preselectedElements);
}

class MainNavigatorStateOpenGalleryForVideo extends MainNavigatorState {
  final List<String> preselectedVideo;

  const MainNavigatorStateOpenGalleryForVideo(this.preselectedVideo)
      : super(preselectedVideo);
}

class MainNavigatorStateShowAddDialog extends MainNavigatorState {
  MainNavigatorStateShowAddDialog() : super([]);
}

class MainNavigatorStateShowTimeLine extends MainNavigatorState {
  MainNavigatorStateShowTimeLine() : super([]);
}

class MainNavigatorStateShowSearch extends MainNavigatorState {
  MainNavigatorStateShowSearch() : super([]);
}

class MainNavigatorStateOpenCamera extends MainNavigatorState {
  MainNavigatorStateOpenCamera() : super([]);
}
