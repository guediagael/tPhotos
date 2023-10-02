import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tphotos/action_listeners/welcome_action_listener.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_builder.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_listener.dart';
import 'package:tphotos/bloc/welcome/nav/welcome_nav_bloc.dart';
import 'package:tphotos/bloc/welcome/nav/welcome_nav_event.dart';
import 'package:tphotos/bloc/welcome/nav/welcome_nav_state.dart';
import 'package:tphotos/rich_button/rich_button_state_manager.dart';
import 'package:tphotos/services/telegram.dart';
import 'package:tphotos/ui/screens/welcome_screen.dart';

class WelcomeDispatcher extends StatefulWidget {
  final String apiHash;
  final String appVersion;
  final int applicationId;
  final String? systemLanguage;
  final String? systemVersion;
  final String? deviceModel;

  const WelcomeDispatcher(
      {required this.apiHash,
      required this.appVersion,
      required this.applicationId,
      this.systemLanguage,
      this.systemVersion,
      this.deviceModel,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _WelcomeDispatcherState();

  static Widget buildWelcomeScreen(
      {required String apiHash,
      required String appVersion,
      required int applicationId,
      String? systemLanguage,
      String? systemVersion,
      String? deviceModel,
      Key? key}) {
    // final dataManager = DataManagerImpl.getInstance();
    final welcomeScreen = MultiProvider(
      providers: [
        BlocProvider(create: (_) => WelcomeNavigatorBloc()),
        // BlocProvider(create: (_) => WelcomeBloc(dataManager.preferencesIdApi))
      ],
      child: Provider<TelegramService>(
        create: (_) => TelegramService(
            apiHash: apiHash,
            applicationId: applicationId,
            appVersion: appVersion),
        child: WelcomeDispatcher(
          apiHash: apiHash,
          appVersion: appVersion,
          applicationId: applicationId,
          systemLanguage: systemLanguage,
          systemVersion: systemVersion,
          deviceModel: deviceModel,
          key: key,
        ),
      ),
    );
    return welcomeScreen;
  }
}

class _WelcomeDispatcherState extends State<WelcomeDispatcher>
    with WelcomeActionListener {
  late RichButtonState _buttonState;
  late final WelcomeNavigatorBloc _welcomeNavigatorBloc;

  @override
  void initState() {
    _buttonState = RichButtonState.initial;
    _welcomeNavigatorBloc = WelcomeNavigatorBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseNavigatorBlocListener(
      bloc: _welcomeNavigatorBloc,
      navListener: (_, __) {},
      child: BaseNavigatorBlocBuilder(
        bloc: _welcomeNavigatorBloc,
        buildWhenCondition: (prevState, currentState) {
          return (prevState != currentState) &&
              (currentState is WelComeNavigatorStateInitial);
        },
        navigatorBlocWidgetBuilder: (ctx, state) {
          return WelcomeScreen(
            welcomeActionListener: this,
            richButtonState: _buttonState,
          );
        },
      ),
    );
  }

  @override
  void onButtonPressed() {
    debugPrint("welcome_dispatcher::onButtonPressed");
    _welcomeNavigatorBloc
        .add(const WelcomeNavigationEventOpenPhoneNumberLogin());
  }
}
