import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tphotos/action_listeners/main_action_listener.dart';
import 'package:tphotos/bloc/base/data/base_bloc_builder.dart';
import 'package:tphotos/bloc/base/data/base_bloc_listener.dart';
import 'package:tphotos/bloc/base/data/base_event.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_builder.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_listener.dart';
import 'package:tphotos/bloc/main/data/main_bloc.dart';
import 'package:tphotos/bloc/main/data/main_event.dart';
import 'package:tphotos/bloc/main/data/main_state.dart';
import 'package:tphotos/bloc/main/nav/main_nav_bloc.dart';
import 'package:tphotos/bloc/main/nav/main_nav_state.dart';
import 'package:tphotos/dispatchers/folder_selection_dispatcher.dart';
import 'package:tphotos/dispatchers/settings_dispatcher.dart';
import 'package:tphotos/ui/screens/main_screen.dart';

class MainScreenDispatcher extends StatefulWidget {
  const MainScreenDispatcher({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenDispatcherState();

  static Widget buildMainScreen() {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => MainNavigatorBloc()),
        BlocProvider(create: (_) => MainBloc())
      ],
      child: const MainScreenDispatcher(),
    );
  }
}

class _MainScreenDispatcherState extends State<MainScreenDispatcher>
    with MainActionListener {
  final int timelineScreen = 0;
  final int searchScreen = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseNavigatorBlocListener(
      bloc: context.read<MainNavigatorBloc>(),
      navListener: (navCtx, state) {},
      child: BaseNavigatorBlocBuilder(
        bloc: context.read<MainNavigatorBloc>(),
        buildWhenCondition: (prevState, currentState) {
          return (currentState != prevState) &&
              (currentState is! MainNavigatorStateShowSettings) &&
              (currentState is! MainNavigatorStateShowAddDialog) &&
              (currentState is! MainNavigatorStateOpenGallery);
        },
        navigatorBlocWidgetBuilder: (navBlocCtx, navState) {
          return BaseBlocListener(
            bloc: context.read<MainBloc>()
              ..add(MainEventCheckFirstLaunchFlag()),
            navigatorBloc: context.read<MainNavigatorBloc>(),
            listener: (ctx, state) {
              if (state is MainStateFirstLaunchFlagLoaded) {
                if (state.isFirstLaunch) {
                  context
                      .read<MainBloc>()
                      .add(FilesPermissionRequestEvent((value) {
                    context
                        .read<MainBloc>()
                        .add(MainEventPermissionRequested());
                  }));
                } else {
                  context.read<MainBloc>().add(MainEventPermissionRequested());
                }
              }
            },
            child: BaseBlocBuilder(
              bloc: context.read<MainBloc>(),
              builder: (ctx, state) {
                if (state is MainStateInitial ||
                    ((state is MainStateFirstLaunchFlagLoaded) &&
                        (state.isFirstLaunch))) {
                  return Container();
                }
                if (state is MainStateFolderCountLoaded) {
                  return MainScreen(
                    mainActionListener: this,
                    shouldShowFab: state.count == 0,
                  );
                }
                return MainScreen(mainActionListener: this);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void addMediaSourceSelected() async {
    context.read<MainBloc>().add(FilesPermissionRequestEvent((value) {
      if (value) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) =>
                FolderSelectionDispatcher.buildFolderSelectionScreen()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No Folder Selected")));
      }
    }));
  }

  @override
  void settingsSelected() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => SettingsDispatcher.buildSettingScreen()));
  }
}
