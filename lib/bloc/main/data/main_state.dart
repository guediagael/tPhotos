import 'package:tphotos/bloc/base/data/base_state.dart';

class MainState extends BaseState {
  const MainState(List<Object?> properties) : super(properties);
}

class MainStateInitial extends MainState {
  MainStateInitial():super([]);

}

class MainStateFirstLaunchFlagLoaded extends MainState {
  final bool isFirstLaunch;

  MainStateFirstLaunchFlagLoaded(this.isFirstLaunch) : super([isFirstLaunch]);
}


