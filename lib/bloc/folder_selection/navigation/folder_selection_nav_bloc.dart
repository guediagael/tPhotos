import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_state.dart';
import 'package:tphotos/bloc/base/navigator/base_navigator_bloc.dart';
import 'package:tphotos/bloc/folder_selection/navigation/folder_selection_nav_event.dart';
import 'package:tphotos/bloc/folder_selection/navigation/folder_selection_nav_state.dart';

class FolderSelectionNavigationBloc extends BaseNavigatorBloc {
  FolderSelectionNavigationBloc()
      : super(FolderSelectionNavigationStateInitial()) {
    on<FolderSelectionNavigationEventSelectionSaved>(_selectionSaved);
  }

  FutureOr<void> _selectionSaved(
      FolderSelectionNavigationEventSelectionSaved event,
      Emitter<BaseNavigatorState> emitter) {
    emitter(FolderSelectionNavigationStateFoldersSaved());
  }
}
