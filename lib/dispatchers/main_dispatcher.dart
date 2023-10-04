import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tphotos/action_listeners/main_action_listener.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_builder.dart';
import 'package:tphotos/bloc/main/nav/main_nav_bloc.dart';
import 'package:tphotos/bloc/main/nav/main_nav_state.dart';
import 'package:tphotos/dispatchers/settings_dispatcher.dart';
import 'package:tphotos/ui/screens/main_screen.dart';
import 'package:tphotos/ui/screens/settings_screen.dart';

class MainScreenDispatcher extends StatefulWidget {
  const MainScreenDispatcher({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenDispatcherState();

  static Widget buildMainScreen() {
    return MultiProvider(
      providers: [BlocProvider(create: (_) => MainNavigatorBloc())],
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
    return BaseNavigatorBlocBuilder(
      bloc: context.watch<MainNavigatorBloc>(),
      buildWhenCondition: (prevState, currentState) {
        return (currentState != prevState) &&
            (currentState is! MainNavigatorStateShowSettings) &&
            (currentState is! MainNavigatorStateShowAddDialog) &&
            (currentState is! MainNavigatorStateOpenGallery) &&
            (currentState is! MainNavigatorStateOpenCamera);
      },
      navigatorBlocWidgetBuilder: (navBlocCtx, navState) {
        return MainScreen(
          mainActionListener: this,
        );
      },
    );
  }

  @override
  void addPictureSourceSelected() {
    // TODO: implement addPictureSelected
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
}
