import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_state.dart';
import 'package:tphotos/bloc/base/navigator/base_navigator_bloc.dart';

import 'main_nav_event.dart';
import 'main_nav_state.dart';

class MainNavigatorBloc extends BaseNavigatorBloc {
  MainNavigatorBloc() : super(MainNavigatorStateShowTimeLine()) {
    on<MainNavigatorEventShowSearch>(_onShowSearch);
    on<MainNavigatorEventShowTimeLine>(_onShowTimeline);
    on<MainNavigatorEventShowSettings>(_onShowSettings);
  }

  void _onShowSearch(MainNavigatorEventShowSearch mainNavigatorEventShowSearch,
      Emitter<BaseNavigatorState> emitter) {
    emitter(MainNavigatorStateShowSearch());
  }

  void _onShowTimeline(
      MainNavigatorEventShowTimeLine mainNavigatorEventShowTimeLine,
      Emitter<BaseNavigatorState> emitter) {
    emitter(MainNavigatorStateShowTimeLine());
  }

  void _onShowSettings(
      MainNavigatorEventShowSettings mainNavigatorEventShowSettings,
      Emitter<BaseNavigatorState> emitter) {
    emitter(MainNavigatorStateShowSettings());
  }
}
