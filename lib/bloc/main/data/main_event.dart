import 'package:tphotos/bloc/base/data/base_event.dart';

class MainEvent extends BaseEvent {
  const MainEvent(List<Object?> properties) : super(properties);
}

class MainEventCheckFirstLaunchFlag extends MainEvent {
  MainEventCheckFirstLaunchFlag() : super([]);
}

class MainEventPermissionRequested extends MainEvent {
  MainEventPermissionRequested() : super([]);
}

class MainEventCheckUpdatedRootPaths extends MainEvent {
  MainEventCheckUpdatedRootPaths() : super([]);
}
