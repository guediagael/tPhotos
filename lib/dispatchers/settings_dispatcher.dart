import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/action_listeners/settings_action_listener.dart';
import 'package:tphotos/bloc/base/data/base_bloc_builder.dart';
import 'package:tphotos/bloc/base/data/base_bloc_listener.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_builder.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_listener.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_event.dart';
import 'package:tphotos/bloc/settings/data/settings_bloc.dart';
import 'package:tphotos/bloc/settings/data/settings_event.dart';
import 'package:tphotos/bloc/settings/data/settings_state.dart';
import 'package:tphotos/bloc/settings/nav/settings_nav_bloc.dart';
import 'package:tphotos/bloc/settings/nav/settings_nav_state.dart';
import 'package:tphotos/data/data_manager_impl.dart';
import 'package:tphotos/ui/screens/settings_screen.dart';

class SettingsDispatcher extends StatefulWidget {
  const SettingsDispatcher({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsDispatcherState();

  static Widget buildSettingScreen({Key? key}) {
    final dataManager = DataManagerImpl.getInstance();
    final screenSettings = MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SettingsNavigatorBloc()),
          BlocProvider(
              create: (_) =>
                  SettingsBloc(
                      preferencesSettingsApi: dataManager
                          .preferencesSettingsApi,
                      preferencesIdApi: dataManager.preferencesIdApi))
        ],
        child: SettingsDispatcher(
          key: key,
        ));
    return screenSettings;
  }
}

class _SettingsDispatcherState extends State<SettingsDispatcher>
    with SettingsActionListener {
  @override
  Widget build(BuildContext context) {
    return BaseNavigatorBlocListener<SettingsNavigatorBloc,
        SettingsNavigatorState>(
      bloc: context.watch<SettingsNavigatorBloc>(),
      navListener: (navContext, navState) {},
      child: BaseNavigatorBlocBuilder(
        bloc: context.watch<SettingsNavigatorBloc>(),
        navigatorBlocWidgetBuilder: (navContext, navState) {
          return BaseBlocListener(
              bloc: context.watch<SettingsBloc>(),
              navigatorBloc: context.read<SettingsNavigatorBloc>(),
              listener: (ctx, state) {
                if (state is SettingsStateSpaceCleared) {
                  context
                      .read<SettingsNavigatorBloc>()
                      .add(BaseNavigatorEventShowSnackBar("Space cleared"));
                }
              },
              child: BaseBlocBuilder(
                  bloc: context.watch<SettingsBloc>(),
                  buildWhenCondition: (prevState, newState) {
                    return (newState is! SettingsStateSpaceCleared) &&
                        ((prevState != newState) ||
                            (newState is SettingStateInitial));
                  },
                  builder: (context, state) {
                    return SettingsScreen(
                      actionListener: this,
                      settings: (state as SettingsContainerState).settings,
                    );
                  }));
        },
      ),
    );
  }

  @override
  void onCloseSettingsPressed() {
    Navigator.of(context).pop();
  }

  @override
  void onDeleteAccount() {
    debugPrint("settings_dispatcher::onDeleteAccount");
    // TODO: implement onDeleteAccount
  }

  @override
  void onFreeUpSpaceOnDevice() {
    debugPrint("settings_dispatcher::onFreeUpSpaceOnDevice");
    context.read<SettingsBloc>().add(const SettingsEventFreeUpSpace());
  }

  @override
  void onLegalNoticePressed() {
    debugPrint("settings_dispatcher::onLegalNoticePressed");
    // TODO: implement onLegalNoticePressed
  }

  @override
  void onSelectFolders() {
    debugPrint("settings_dispatcher::onSelectFolders");
    _showFolderSelector(
        (context
            .read<SettingsBloc>()
            .state as SettingsContainerState)
            .settings
            .selectedFolders);
  }

  @override
  void onSyncNowPressed() {
    debugPrint("settings_dispatcher::onSyncNowPressed");
    context
        .read<SettingsBloc>()
        .add(const SettingsEventTriggerSync());
  }

  @override
  void onTermsOfServicePressed() {
    debugPrint("settings_dispatcher::onTermsOfServicePressed");
    // TODO: implement onTermsOfServicePressed
  }

  @override
  void updateAutoSync(bool newValue) {
    debugPrint("settings_dispatcher::updateAutoSync");
    context.read<SettingsBloc>().add(SettingsEventUpdateAutoSync(newValue));
  }

  @override
  void updateDeleteAfterSave(bool newValue) {
    debugPrint("settings_dispatcher::updateDeleteAfterSave");
    context
        .read<SettingsBloc>()
        .add(SettingsEventUpdateDeleteAfterSave(newValue));
  }

  void _showFolderSelector(List<String> preselectedFolders) {
    FilePicker.platform
        .getDirectoryPath(
        dialogTitle: "Please select one directory to be loaded ")
        .then((value) {
      if (value != null) {
        var dir = Directory(value);
        try {
          var dirList = dir.list();
          _listDirs(dirList);
        } on Error catch (e) {
          debugPrint(e.toString());
          debugPrintStack(stackTrace: e.stackTrace,
              label: "settings_dispatcher::_showFolderSelector");
        }
      }
      if (value != null && !preselectedFolders.contains(value)) {
        preselectedFolders.add(value);
        context
            .read<SettingsBloc>()
            .add(SettingsEventUpdatedSyncedFolders(preselectedFolders));
      }
    });
  }

  void _listDirs(Stream<FileSystemEntity> dirList) async {
    await for (final FileSystemEntity f in dirList) {
      if (f is File) {
        debugPrint('Found file ${f.path}');
      } else if (f is Directory) {
        debugPrint('Found dir ${f.path}');
      }
    }
  }
}
