import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tphotos/action_listeners/main_action_listener.dart';
import 'package:tphotos/bloc/base/data/base_bloc_builder.dart';
import 'package:tphotos/bloc/base/data/base_bloc_listener.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_builder.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_listener.dart';
import 'package:tphotos/bloc/main/data/main_bloc.dart';
import 'package:tphotos/bloc/main/data/main_event.dart';
import 'package:tphotos/bloc/main/data/main_state.dart';
import 'package:tphotos/bloc/main/nav/main_nav_bloc.dart';
import 'package:tphotos/bloc/main/nav/main_nav_state.dart';
import 'package:tphotos/dispatchers/settings_dispatcher.dart';
import 'package:tphotos/ui/screens/main_screen.dart';
import 'package:file_selector/file_selector.dart';
import 'package:tphotos/utils/permissions.dart';

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
  late final ImagePicker _imagePicker;
  final int timelineScreen = 0;
  final int searchScreen = 1;

  @override
  void initState() {
    _imagePicker = ImagePicker();
    _getLostData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseNavigatorBlocListener(
      bloc: context.watch<MainNavigatorBloc>(),
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
            bloc: context.watch<MainBloc>()
              ..add(MainEventCheckFirstLaunchFlag()),
            navigatorBloc: context.read<MainNavigatorBloc>(),
            listener: (ctx, state) {
              if (state is MainStateFirstLaunchFlagLoaded) {
                if (state.isFirstLaunch) {
                  //TODO: context
                  //     .read()<MainNavigatorBloc>()
                  //     .add(BaseNavigatorEventRequestFoldersPermissions());
                  _requestPermissions();
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
                return MainScreen(mainActionListener: this);
              },
            ),
          );
        },
      ),
    );
  }

  void _requestPermissions() async {
    checkStoragePermission(context).then((value) {
      context.read<MainBloc>().add(MainEventPermissionRequested());
    });
  }

  @override
  void addMediaSourceSelected() async {
    checkStoragePermission(context).then((value) {
      if (value) {
        //TODO: chose folders
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No Folder Selected")));
      }
    });
  }

  @override
  void openGalleryForImageSelected() async {
    debugPrint(
        "main_screen_dispatcher::openGalleryForImageSelected opening gallery");
    final List<XFile> selectedImages =
        await _imagePicker.pickMultiImage(imageQuality: 100);
    if (selectedImages.isNotEmpty) {
      debugPrint(
          "main_screen_dispatcher::openGalleryForImageSelected uploading images .... $selectedImages");
    }
  }

  @override
  void openGalleryForVideoSelected() async {
    debugPrint(
        "main_screen_dispatcher::openGalleryForVideoSelected Opening Video gallery");
    final XFile? video =
        await _imagePicker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      debugPrint(
          "main_screen_dispatcher::openGalleryForVideoSelected new image .... $video");
    }
  }

  @override
  void settingsSelected() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => SettingsDispatcher.buildSettingScreen()));
  }

  Future<void> _getLostData() async {
    final LostDataResponse response = await _imagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.files != null) {
      debugPrint("uploading lost images .... ${response.files}");
    } else {
      const errorDetail = FlutterErrorDetails(
          exception: "Main::getLostData:: "
              "response not empty but files ==null");
      FlutterError.presentError(errorDetail);
    }
  }

  Future<List<String>> getDirs() async {
    const String confirmButtonText = 'Choose';
    final List<String?> directoryPaths = await getDirectoryPaths(
      confirmButtonText: confirmButtonText,
    );
    if (directoryPaths.isEmpty) {
      // Operation was canceled by the user.
      return [];
    }

    List<String> paths = [];
    for (final String? path in directoryPaths) {
      if (path != null) {
        paths.add(path);
      }
    }
    debugPrint("main_dispatcher::getDirs:: >>directoriesSelected:  $paths");
    return paths;
  }
}
