import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tphotos/action_listeners/folder_selection_listener.dart';
import 'package:tphotos/bloc/base/data/base_bloc_builder.dart';
import 'package:tphotos/bloc/base/data/base_bloc_listener.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_builder.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_listener.dart';
import 'package:tphotos/bloc/folder_selection/data/folder_selection_bloc.dart';
import 'package:tphotos/bloc/folder_selection/data/folder_selection_event.dart';
import 'package:tphotos/bloc/folder_selection/data/folder_selection_state.dart';
import 'package:tphotos/bloc/folder_selection/navigation/folder_selection_nav_bloc.dart';
import 'package:tphotos/bloc/folder_selection/navigation/folder_selection_nav_event.dart';
import 'package:tphotos/bloc/folder_selection/navigation/folder_selection_nav_state.dart';
import 'package:tphotos/ui/screens/folder_selection.dart';

class FolderSelectionDispatcher extends StatefulWidget {
  final bool fromSettings;

  const FolderSelectionDispatcher({super.key, required this.fromSettings});

  @override
  State<StatefulWidget> createState() => FolderSelectionDispatcherState();

  static Widget buildFolderSelectionScreen({bool fromSettings = false}) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => FolderSelectionNavigationBloc()),
        BlocProvider(create: (_) => FolderSelectionBloc())
      ],
      child: FolderSelectionDispatcher(fromSettings: fromSettings),
    );
  }
}

class FolderSelectionDispatcherState extends State<FolderSelectionDispatcher>
    with FolderSelectionListener {
  @override
  void didChangeDependencies() {
    context
        .read<FolderSelectionBloc>()
        .add(FolderSelectionEventLoadSelection());

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BaseNavigatorBlocListener(
      bloc: context.read<FolderSelectionNavigationBloc>(),
      navListener: (navCtx, state) {
        if (state is FolderSelectionNavigationStateFoldersSaved) {
          Navigator.pop(context);
        }
      },
      child: BaseNavigatorBlocBuilder(
        bloc: context.read<FolderSelectionNavigationBloc>(),
        navigatorBlocWidgetBuilder: (navCtx, navState) {
          return BaseBlocListener(
            bloc: context.read<FolderSelectionBloc>(),
            navigatorBloc: context.read<FolderSelectionNavigationBloc>(),
            listener: (ctx, state) {
              if (state is FolderSelectionStateSaved) {
                context
                    .read<FolderSelectionNavigationBloc>()
                    .add(FolderSelectionNavigationEventSelectionSaved());
              }
            },
            child: BaseBlocBuilder(
              bloc: context.read<FolderSelectionBloc>(),
              builder: (ctx, state) {
                if (state is FolderSelectionStateSelectionUpdated) {
                  return FolderSelectionScreen(
                    selectedFolders: state.selectedFolders,
                    listener: this,
                    shouldShowModelOnOpen: widget.fromSettings == false,
                  );
                }
                return FolderSelectionScreen(
                    selectedFolders: const [],
                    listener: this,
                    shouldShowModelOnOpen: widget.fromSettings == false);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void onFolderSelectionClose(bool save, List<String> selectedFolders) {
    if (save) {
      context
          .read<FolderSelectionBloc>()
          .add(FolderSelectionEventSaveSelection(selectedFolders));
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void onFolderSelected(String folder, List<String> selectedFolders) {
    context.read<FolderSelectionBloc>().add(
        FolderSelectionEventNewFolderSelected(
            selectedFolders: selectedFolders, newFolder: folder));
  }

  @override
  void onFolderUnselected(int folderIndex, List<String> selectedFolders) {
    context.read<FolderSelectionBloc>().add(
        FolderSelectionEventFolderUnSelected(
            selectedFolders: selectedFolders, unselectedIndex: folderIndex));
  }
}
