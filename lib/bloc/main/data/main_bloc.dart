import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/bloc/base/data/base_data_bloc.dart';
import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/bloc/main/data/main_event.dart';
import 'package:tphotos/bloc/main/data/main_state.dart';
import 'package:tphotos/data/data_manager_impl.dart';

class MainBloc extends BaseBloc {
  MainBloc() : super(MainStateInitial()) {
    on<MainEventCheckFirstLaunchFlag>(_onCheckFirstLaunchFlags);
    on<MainEventPermissionRequested>(_onPermissionRequested);
  }

  void _onCheckFirstLaunchFlags(
      MainEventCheckFirstLaunchFlag event, Emitter<BaseState> emitter) {
    bool isFirstLaunch = DataManagerImpl.getInstance()
        .preferencesSettingsApi
        .checkIsFirstLaunch();
    emitter(MainStateFirstLaunchFlagLoaded(isFirstLaunch));
    DataManagerImpl.getInstance()
        .preferencesSettingsApi
        .updateFirstLaunchFlag(false);
  }

  FutureOr<void> _onPermissionRequested(MainEventPermissionRequested event, Emitter<BaseState> emitter) {
    emitter(MainStateFirstLaunchFlagLoaded(false));

  }
}
