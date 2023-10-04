import 'package:tphotos/bloc/base/navigator/base_nav_event.dart';
import 'package:tphotos/bloc/base/navigator/base_navigator_bloc.dart';

import 'settings_nav_event.dart';
import 'settings_nav_state.dart';

class SettingsNavigatorBloc extends BaseNavigatorBloc {
  SettingsNavigatorBloc() : super(SettingsNavigatorInitialState()) {
    on<SettingsNavigatorCloseEvent>((event, emit) {
      add(BaseNavigatorEventPop(state));
    });
  }
}
